// One application, end to end — same flow as the website's application page:
// where it stands, what the university published (offer letter, admit card,
// exam) and what the student has to do next.
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../data/admission_service.dart';

const _gold = Color(0xFFF5B829);
const _night = Color(0xFF161326);
const _brand = Color(0xFF745CF5);

class ApplicationDetailsScreen extends ConsumerWidget {
  final String? applicationId;

  const ApplicationDetailsScreen({super.key, this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = applicationId ?? '';
    final async = ref.watch(applicationProvider(id));

    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator(color: NeoColors.green)),
          error: (e, _) => _Missing(onBack: () => _back(context)),
          data: (app) => app == null ? _Missing(onBack: () => _back(context)) : _Body(app: app),
        ),
      ),
    );
  }
}

void _back(BuildContext context) => context.canPop() ? context.pop() : context.go('/applications');

Future<void> _open(BuildContext context, String? url) async {
  if (url == null || url.isEmpty) return;
  final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Couldn’t open the file. Try again.')));
  }
}

String _fmt(DateTime? d, {bool time = false}) =>
    d == null ? '—' : DateFormat(time ? 'd MMM yyyy, h:mm a' : 'd MMM yyyy').format(d.toLocal());

class _Missing extends StatelessWidget {
  final VoidCallback onBack;
  const _Missing({required this.onBack});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('🔍', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            const Text('We couldn’t find this application',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('It may have been removed, or it belongs to another account.',
                textAlign: TextAlign.center, style: TextStyle(color: NeoColors.subDark, fontSize: 13)),
            const SizedBox(height: 18),
            GreenBtn(label: 'All applications', small: true, onClick: onBack),
          ]),
        ),
      );
}

// ── body ───────────────────────────────────────────────────────────────────
class _Body extends ConsumerWidget {
  final Map<String, dynamic> app;
  const _Body({required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = app['id'] as String;
    final status = normalizeStatus(app['status'] as String?);
    final generated = ref.watch(generatedDocumentsProvider(id)).value ?? const [];
    final shared = ref.watch(sharedDocumentsProvider(id)).value ?? const [];
    final exams = ref.watch(examSchedulesProvider('${app['universityId'] ?? ''}|${app['programId'] ?? ''}')).value ?? const [];
    Map<String, dynamic>? latest(String type) {
      for (final g in generated) {
        if (g['type'] == type) return g;
      }
      return null;
    }

    final history = [...(app['statusHistory'] as List? ?? const [])].whereType<Map>().toList()
      ..sort((a, b) => (toDate(b['date'])?.millisecondsSinceEpoch ?? 0).compareTo(toDate(a['date'])?.millisecondsSinceEpoch ?? 0));
    final closed = closedStatuses.contains(status) || status == 'enrolled';

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
      children: [
        Row(children: [
          _RoundBtn(icon: Icons.arrow_back_rounded, onTap: () => _back(context)),
          const Spacer(),
          _StatusChip(status: status),
        ]),
        const SizedBox(height: 18),
        Text((app['universityName'] ?? 'University').toString(), style: const TextStyle(color: NeoColors.subDark, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text((app['programName'] ?? app['program'] ?? app['courseName'] ?? 'Program').toString(),
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.6, height: 1.1)),
        const SizedBox(height: 18),
        _Journey(status: status),
        const SizedBox(height: 14),
        _NextStep(app: app, status: status, offerLetter: latest('offer_letter'), certificate: latest('enrollment_certificate')),
        if (generated.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Section(
            title: 'From the university',
            child: Column(children: [
              for (final g in generated)
                _FileRow(
                  title: const {'offer_letter': 'Offer letter', 'admit_card': 'Admit card', 'enrollment_certificate': 'Enrollment certificate'}[g['type']] ??
                      (g['type'] ?? 'Document').toString(),
                  sub: 'Issued ${_fmt(toDate(g['generatedAt']))}',
                  onTap: () => _open(context, g['url'] as String?),
                ),
            ]),
          ),
        ],
        if (exams.isNotEmpty || latest('admit_card') != null) ...[
          const SizedBox(height: 14),
          _ExamCard(exams: exams, admitCard: latest('admit_card')),
        ],
        const SizedBox(height: 14),
        _DocumentsCard(appId: id, shared: shared, closed: closed),
        const SizedBox(height: 14),
        _Section(
          title: 'Activity',
          child: history.isEmpty
              ? Text('Applied ${_fmt(toDate(app['createdAt']))}. Updates from the university will show here.',
                  style: const TextStyle(color: NeoColors.subDark, fontSize: 13))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < history.length && i < 8; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(color: i == 0 ? _brand : NeoColors.borderDark, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(statusLabel(normalizeStatus(history[i]['status']?.toString())),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5)),
                              if ((history[i]['note'] ?? '').toString().isNotEmpty)
                                Text(history[i]['note'].toString(), style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                              Text(_fmt(toDate(history[i]['date']), time: true), style: const TextStyle(color: NeoColors.subDark, fontSize: 11.5)),
                            ]),
                          ),
                        ]),
                      ),
                  ],
                ),
        ),
        if (!closed) ...[
          const SizedBox(height: 14),
          PillBtn(
            label: 'Practise the interview',
            icon: '🎙',
            bg: NeoColors.surfDark,
            flex: true,
            onClick: () => context.push('/interview'),
          ),
        ],
      ],
    );
  }
}

// ── small pieces ───────────────────────────────────────────────────────────
class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Back',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(21), border: Border.all(color: NeoColors.borderDark)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      );
}

Color _toneOf(String s) {
  if (closedStatuses.contains(s)) return s == 'rejected' ? NeoColors.red : NeoColors.subDark;
  if (['selected', 'allotted', 'seat_accepted', 'payment_verified', 'enrolled'].contains(s)) return NeoColors.green;
  if (['under_review', 'fee_paid', 'waitlisted'].contains(s)) return _gold;
  return _brand;
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});
  @override
  Widget build(BuildContext context) {
    final c = _toneOf(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withValues(alpha: 0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 7),
        Text(statusLabel(status), style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 12)),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _Section({required this.title, required this.child, this.trailing});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(24), border: Border.all(color: NeoColors.borderDark)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.2))),
            if (trailing != null) trailing!,
          ]),
          const SizedBox(height: 12),
          child,
        ]),
      );
}

class _FileRow extends StatelessWidget {
  final String title;
  final String sub;
  final VoidCallback onTap;
  final Widget? badge;
  const _FileRow({required this.title, required this.sub, required this.onTap, this.badge});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: NeoColors.surf2Dark, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: _brand.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.description_outlined, color: Color(0xFFB2A2FF), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5)),
                  if (badge != null) Padding(padding: const EdgeInsets.only(top: 3), child: badge!) else Text(sub, style: const TextStyle(color: NeoColors.subDark, fontSize: 11.5)),
                ]),
              ),
              const Icon(Icons.download_rounded, color: NeoColors.subDark, size: 18),
            ]),
          ),
        ),
      );
}

// ── journey ────────────────────────────────────────────────────────────────
class _Journey extends StatelessWidget {
  final String status;
  const _Journey({required this.status});
  static const _labels = ['Applied', 'Review', 'Docs', 'Offer', 'Seat', 'Fee', 'Enrolled'];
  @override
  Widget build(BuildContext context) {
    final closed = closedStatuses.contains(status);
    final reached = closed ? 1 : stageOf(status); // 1..7
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(24), border: Border.all(color: NeoColors.borderDark)),
      child: Row(children: [
        for (var i = 0; i < _labels.length; i++)
          Expanded(
            child: Column(children: [
              Row(children: [
                Expanded(child: Container(height: 3, color: i == 0 ? Colors.transparent : (i < reached ? _brand : NeoColors.borderDark))),
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: closed && i == reached - 1
                        ? NeoColors.red
                        : i < reached - 1 || status == 'enrolled'
                            ? _brand
                            : i == reached - 1
                                ? NeoColors.bgDark
                                : NeoColors.surf2Dark,
                    border: i == reached - 1 && !closed && status != 'enrolled' ? Border.all(color: _brand, width: 2.5) : null,
                  ),
                  child: i < reached - 1 || status == 'enrolled'
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : closed && i == reached - 1
                          ? const Icon(Icons.close_rounded, size: 14, color: Colors.white)
                          : Text('${i + 1}', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: i == reached - 1 ? Colors.white : NeoColors.subDark)),
                ),
                Expanded(child: Container(height: 3, color: i == _labels.length - 1 ? Colors.transparent : (i < reached - 1 ? _brand : NeoColors.borderDark))),
              ]),
              const SizedBox(height: 6),
              Text(_labels[i],
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: i < reached ? Colors.white : NeoColors.subDark)),
            ]),
          ),
      ]),
    );
  }
}

// ── the one thing to do next ───────────────────────────────────────────────
class _NextStep extends StatefulWidget {
  final Map<String, dynamic> app;
  final String status;
  final Map<String, dynamic>? offerLetter;
  final Map<String, dynamic>? certificate;
  const _NextStep({required this.app, required this.status, this.offerLetter, this.certificate});
  @override
  State<_NextStep> createState() => _NextStepState();
}

class _NextStepState extends State<_NextStep> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() fn, String done) async {
    setState(() => _busy = true);
    try {
      await fn();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is AdmissionException ? e.message : 'Something went wrong. Try again.')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _askReason({required String title, required String body, required String confirm, required String hint}) {
    final ctrl = TextEditingController();
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: NeoColors.surfDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(22, 22, 22, MediaQuery.of(ctx).viewInsets.bottom + 22),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: NeoColors.subDark, fontSize: 13)),
          const SizedBox(height: 16),
          _Field(controller: ctrl, label: 'Reason (optional)', hint: hint),
          const SizedBox(height: 16),
          PillBtn(label: confirm, bg: NeoColors.red, flex: true, onClick: () => Navigator.pop(ctx, ctrl.text.trim())),
          const SizedBox(height: 8),
          PillBtn(label: 'Cancel', ghost: true, flex: true, onClick: () => Navigator.pop(ctx)),
        ]),
      ),
    );
  }

  Future<bool> _confirm(String title, String body, String yes) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeoColors.surfDark,
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text(body, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not yet')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(yes, style: const TextStyle(color: _gold, fontWeight: FontWeight.w800))),
        ],
      ),
    );
    return r == true;
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final s = widget.status;
    final id = app['id'] as String;
    final uni = (app['universityName'] ?? 'the university').toString();

    if (offerStatuses.contains(s)) {
      return _NightCard(
        badge: s == 'allotted' ? 'Seat allotted 🎉' : 'Offer received 🎉',
        title: 'Congratulations — $uni wants you.',
        body: 'Read the offer letter, then accept the seat to move on to fee payment. If you’ve chosen another college, decline so the seat goes to someone on the waitlist.',
        children: [
          if (widget.offerLetter != null)
            PillBtn(label: 'Offer letter', icon: '📄', bg: Colors.white, color: _night, flex: true, onClick: () => _open(context, widget.offerLetter!['url'] as String?)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: PillBtn(
                label: _busy ? 'Saving…' : 'Accept seat',
                bg: _gold,
                color: _night,
                flex: true,
                onClick: _busy
                    ? null
                    : () async {
                        if (await _confirm('Accept this seat?', 'You’ll pay the admission fee next and upload the receipt here.', 'Accept')) {
                          _run(() => acceptSeat(id), 'Seat accepted. Pay the fee next.');
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PillBtn(
                label: 'Decline',
                bg: Colors.white.withValues(alpha: 0.1),
                flex: true,
                onClick: _busy
                    ? null
                    : () async {
                        final reason = await _askReason(
                            title: 'Decline this offer?',
                            body: 'This can’t be undone — the university will release your seat.',
                            confirm: 'Decline offer',
                            hint: 'e.g. Joining another college');
                        if (reason != null) _run(() => declineOffer(id, reason), 'Offer declined.');
                      },
              ),
            ),
          ]),
        ],
      );
    }

    if (s == 'seat_accepted') {
      final rejected = (app['paymentDetails'] as Map?)?['status'] == 'rejected';
      return _Section(
        title: 'Pay the admission fee',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Pay using the bank or UPI details in your offer letter, then add the reference number and receipt.',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          if (rejected) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: NeoColors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
              child: Text(
                'Your last payment couldn’t be verified. ${(app['paymentDetails'] as Map?)?['rejectionReason'] ?? 'Check the reference number and receipt, then submit again.'}',
                style: const TextStyle(color: Color(0xFFFF8A8D), fontSize: 12.5),
              ),
            ),
          ],
          const SizedBox(height: 14),
          GreenBtn(label: 'Add payment details', onClick: () => _openFeeSheet(id)),
        ]),
      );
    }

    if (s == 'fee_paid') {
      final p = (app['paymentDetails'] as Map?) ?? {};
      return _Section(
        title: 'Your payment is being checked',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('The admissions office matches your reference number with their bank statement. This usually takes 1–3 working days.',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Text('₹${p['amountPaid'] ?? '—'} · ref ${p['transactionRef'] ?? '—'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          Text('Submitted ${_fmt(toDate(p['submittedAt']))}', style: const TextStyle(color: NeoColors.subDark, fontSize: 12)),
          if (p['receiptUrl'] != null)
            TextButton(onPressed: () => _open(context, p['receiptUrl'] as String?), child: const Text('View your receipt')),
        ]),
      );
    }

    if (s == 'payment_verified' || s == 'enrolled') {
      return _NightCard(
        badge: s == 'enrolled' ? 'Enrolled 🎓' : 'Fee verified',
        title: s == 'enrolled' ? 'You’re enrolled at $uni.' : 'Fee received. Enrollment is next.',
        body: s == 'enrolled'
            ? 'Keep your enrollment certificate handy for hostel allotment and the first day of classes.'
            : 'The university has verified your payment and will confirm your enrollment shortly.',
        children: [
          if (widget.certificate != null)
            PillBtn(label: 'Enrollment certificate', icon: '📄', bg: Colors.white, color: _night, flex: true, onClick: () => _open(context, widget.certificate!['url'] as String?)),
        ],
      );
    }

    if (closedStatuses.contains(s)) {
      final copy = {
        'rejected': ['This application wasn’t successful', (app['rejectionReason'] ?? 'The university didn’t offer a seat this time. Your profile stays ready for other applications.').toString()],
        'offer_declined': ['You declined this offer', 'The university has been told, and the seat has been released.'],
        'withdrawn': ['You withdrew this application', 'The university will no longer process it.'],
      }[s]!;
      return _Section(
        title: copy[0],
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(copy[1], style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 14),
          GreenBtn(label: 'Find other universities', small: true, onClick: () => context.go('/discover')),
        ]),
      );
    }

    const review = {
      'submitted': 'Your application has reached the admissions office. They’ll start by checking your documents.',
      'under_review': 'The admissions office is reviewing your application and documents.',
      'docs_verified': 'Your documents are verified. The university will publish its decision next.',
      'waitlisted': 'You’re on the waitlist. If a seat opens up, your status changes to “Offer received”.',
    };
    return _Section(
      title: 'Nothing to do right now',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${review[s] ?? review['submitted']} We’ll notify you the moment anything changes.', style: const TextStyle(color: Colors.white70, fontSize: 13)),
        if (withdrawableStatuses.contains(s))
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: NeoColors.subDark),
            onPressed: _busy
                ? null
                : () async {
                    final reason = await _askReason(
                        title: 'Withdraw this application?',
                        body: 'Withdrawing can’t be undone. You’d need to apply again.',
                        confirm: 'Withdraw application',
                        hint: 'e.g. Got admission elsewhere');
                    if (reason != null) _run(() => withdrawApplication(id, reason), 'Application withdrawn.');
                  },
            child: const Text('Withdraw this application', style: TextStyle(decoration: TextDecoration.underline)),
          ),
      ]),
    );
  }

  void _openFeeSheet(String id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: NeoColors.surfDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _FeeSheet(appId: id),
    );
  }
}

class _NightCard extends StatelessWidget {
  final String badge;
  final String title;
  final String body;
  final List<Widget> children;
  const _NightCard({required this.badge, required this.title, required this.body, required this.children});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF3A2A8F), _night]),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(color: _gold, borderRadius: BorderRadius.circular(14)),
              child: Text(badge, style: const TextStyle(color: _night, fontWeight: FontWeight.w900, fontSize: 11.5)),
            ),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900, height: 1.15, letterSpacing: -0.4)),
          const SizedBox(height: 8),
          Text(body, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13)),
          const SizedBox(height: 16),
          ...children,
        ]),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboard;
  const _Field({required this.controller, required this.label, required this.hint, this.keyboard});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: NeoColors.subDark),
          hintStyle: const TextStyle(color: NeoColors.mutedDark),
          filled: true,
          fillColor: NeoColors.surf2Dark,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      );
}

class _FeeSheet extends StatefulWidget {
  final String appId;
  const _FeeSheet({required this.appId});
  @override
  State<_FeeSheet> createState() => _FeeSheetState();
}

class _FeeSheetState extends State<_FeeSheet> {
  final _amount = TextEditingController();
  final _ref = TextEditingController();
  DateTime _paidOn = DateTime.now();
  String _mode = 'UPI';
  File? _receipt;
  bool _busy = false;
  String? _error;

  Future<void> _pick() async {
    final r = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png']);
    final path = r?.files.single.path;
    if (path != null) setState(() => _receipt = File(path));
  }

  Future<void> _submit() async {
    if (_receipt == null) {
      setState(() => _error = 'Attach the payment receipt or a screenshot of the transaction.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await submitFeePayment(widget.appId,
          amount: num.tryParse(_amount.text.trim()) ?? 0,
          transactionRef: _ref.text,
          paidOn: DateFormat('yyyy-MM-dd').format(_paidOn),
          mode: _mode,
          receipt: _receipt!);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment submitted for verification.')));
      }
    } catch (e) {
      setState(() => _error = e is AdmissionException ? e.message : 'Upload failed. Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 22, 22, MediaQuery.of(context).viewInsets.bottom + 22),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Fee payment', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          _Field(controller: _amount, label: 'Amount paid (₹)', hint: 'e.g. 50000', keyboard: TextInputType.number),
          const SizedBox(height: 10),
          _Field(controller: _ref, label: 'Transaction / UTR reference', hint: 'e.g. 412345678901'),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final m in const ['UPI', 'NEFT / RTGS / IMPS', 'Demand draft', 'Card', 'Cash at campus'])
              ChoiceChip(
                label: Text(m),
                selected: _mode == m,
                onSelected: (_) => setState(() => _mode = m),
                selectedColor: _brand,
                backgroundColor: NeoColors.surf2Dark,
                labelStyle: TextStyle(color: _mode == m ? Colors.white : Colors.white70, fontWeight: FontWeight.w600),
              ),
          ]),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Paid on', style: TextStyle(color: NeoColors.subDark, fontSize: 12.5)),
            subtitle: Text(DateFormat('d MMM yyyy').format(_paidOn), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            trailing: const Icon(Icons.calendar_month_rounded, color: Colors.white70),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _paidOn, firstDate: DateTime(2024), lastDate: DateTime.now());
              if (d != null) setState(() => _paidOn = d);
            },
          ),
          OutlinedButton.icon(
            onPressed: _pick,
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(_receipt == null ? 'Upload receipt (PDF or image)' : _receipt!.path.split(Platform.pathSeparator).last, overflow: TextOverflow.ellipsis),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white, minimumSize: const Size.fromHeight(48), side: const BorderSide(color: NeoColors.borderDark)),
          ),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Color(0xFFFF8A8D)))),
          const SizedBox(height: 16),
          GreenBtn(label: _busy ? 'Uploading…' : 'Submit for verification', disabled: _busy, onClick: _submit),
        ]),
      ),
    );
  }
}

// ── exam / admit card ──────────────────────────────────────────────────────
class _ExamCard extends StatelessWidget {
  final List<Map<String, dynamic>> exams;
  final Map<String, dynamic>? admitCard;
  const _ExamCard({required this.exams, this.admitCard});
  @override
  Widget build(BuildContext context) => _Section(
        title: 'Entrance test / interview',
        trailing: admitCard == null
            ? null
            : PillBtn(label: 'Admit card', size: 'sm', bg: _brand, onClick: () => _open(context, admitCard!['url'] as String?)),
        child: exams.isEmpty
            ? const Text('Your admit card is ready. The schedule will appear here when the university publishes it.',
                style: TextStyle(color: Colors.white70, fontSize: 13))
            : Column(children: [
                for (final x in exams)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: NeoColors.surf2Dark, borderRadius: BorderRadius.circular(16)),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(width: 4, height: 38, decoration: BoxDecoration(color: _brand, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            '${toDate(x['date']) != null ? DateFormat('EEE, d MMM yyyy').format(toDate(x['date'])!) : 'Date to be announced'}${x['time'] != null ? ', ${x['time']}' : ''}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5),
                          ),
                          if (x['center'] != null) Text('📍 ${x['center']}', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                          if ((x['instructions'] ?? '').toString().isNotEmpty)
                            Padding(padding: const EdgeInsets.only(top: 4), child: Text(x['instructions'].toString(), style: const TextStyle(color: NeoColors.subDark, fontSize: 12))),
                        ]),
                      ),
                    ]),
                  ),
              ]),
      );
}

// ── documents the university sees ──────────────────────────────────────────
class _DocumentsCard extends StatefulWidget {
  final String appId;
  final List<Map<String, dynamic>> shared;
  final bool closed;
  const _DocumentsCard({required this.appId, required this.shared, required this.closed});
  @override
  State<_DocumentsCard> createState() => _DocumentsCardState();
}

class _DocumentsCardState extends State<_DocumentsCard> {
  bool _busy = false;

  Future<void> _share() async {
    setState(() => _busy = true);
    String msg;
    try {
      final n = await shareDocumentsWithApplication(widget.appId);
      msg = n > 0 ? 'Sent $n updated document${n > 1 ? 's' : ''} to the university.' : 'The university already has your latest documents.';
    } catch (_) {
      msg = 'Couldn’t send documents. Try again in a moment.';
    }
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    const labels = {
      'verified': ['Verified', NeoColors.green],
      'rejected': ['Rejected', NeoColors.red],
      'requires_resubmission': ['Re-upload needed', NeoColors.red],
      'under_review': ['In review', _gold],
      'pending': ['Waiting for review', NeoColors.subDark],
    };
    return _Section(
      title: 'Documents with the university',
      trailing: widget.closed
          ? null
          : PillBtn(label: _busy ? 'Sending…' : 'Send latest', size: 'sm', ghost: true, onClick: _busy ? null : _share),
      child: widget.shared.isEmpty
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('The university hasn’t received any documents yet. Upload your marksheets and ID, then tap Send latest.',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 12),
              GreenBtn(label: 'Upload documents', small: true, onClick: () => context.push('/documents')),
            ])
          : Column(children: [
              for (final d in widget.shared)
                Builder(builder: (context) {
                  final l = labels[d['status']] ?? labels['pending']!;
                  final color = l[1] as Color;
                  return _FileRow(
                    title: (d['name'] ?? 'Document').toString(),
                    sub: '',
                    badge: Text(l[0] as String, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w800)),
                    onTap: () => _open(context, d['url'] as String?),
                  );
                }),
            ]),
    );
  }
}

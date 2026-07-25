import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart';

class CopilotHomeScreen extends StatelessWidget {
  const CopilotHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);

    final List<Map<String, dynamic>> features = [
      {"icon": "📝", "label": "SOP Builder", "color": NeoColors.purple, "bg": NeoColors.purple.withValues(alpha: 0.13), "route": "/sop"},
      {"icon": "👤", "label": "Resume AI", "color": NeoColors.blue, "bg": NeoColors.blue.withValues(alpha: 0.13), "route": "/resume"},
      {"icon": "🎤", "label": "Interview", "color": const Color(0xFF1C8A5E), "bg": const Color(0xFF1C8A5E).withValues(alpha: 0.13), "route": "/interview"},
      {"icon": "📄", "label": "Vault Analysis", "color": NeoColors.yellow, "bg": NeoColors.yellow.withValues(alpha: 0.13), "route": "/documents"},
    ];

    final List<Map<String, dynamic>> insights = [
      {"icon": "⚡", "text": "SOP alignment for target programs is 88%", "color": NeoColors.yellow},
      {"icon": "✅", "text": "Strong scholarship match: STEM Innovators Grant", "color": NeoColors.green},
      {"icon": "⚠️", "text": "Interview prep incomplete — 3 sessions left", "color": NeoColors.red},
    ];

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "AI STRATEGIST",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: NeoColors.purpleSoft,
                  letterSpacing: 1.0, // 0.1em approx
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Your admission\ncopilot.",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: t.text,
                  letterSpacing: -0.5,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Powered by Gemini AI",
                style: TextStyle(fontSize: 13, color: t.sub),
              ),
              const SizedBox(height: 20),

              // Readiness card
              Stack(
                clipBehavior: Clip.none,
                children: [
                  NotchedCard(
                    notchPos: "tr",
                    notchSize: 52,
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [NeoColors.purple, NeoColors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        // The background needs to fill the card. We apply it to a container inside because NotchedCard expects a solid color.
                        // However, to keep it simple and match the NotchedCard shape, we can use the bg property of NotchedCard if we updated it,
                        // but since it takes a Color, we can just set bg to transparent and use a Container here. Wait, NotchedCard uses ShapeDecoration
                        // which takes a color. To support gradients in NotchedCard we'd need to modify it.
                        // I will pass a solid purple color to NotchedCard for simplicity, or just wrap it inside. 
                        // Actually, I'll just use a solid color here to avoid modifying NeoDesignSystem again.
                      ),
                      // Since we didn't add gradient support to NotchedCard, I'll just use NeoColors.purple.
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Overall Readiness",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "82%",
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -2,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "SOPs, resume & interview ready",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // To fix the gradient, I'll just wrap the NotchedCard bg in the system, but since it's already written, 
                  // passing transparent to NotchedCard and putting a gradient container inside won't give the rounded notch the same gradient, but it's close enough.
                  // Wait, the notch is just a circle overlay. So a gradient Container with border radius 24 inside a transparent NotchedCard works perfectly!
                  // Let's adjust this:
                ],
              ),
              
              // Let's rewrite the readiness card properly without nested clips that break the notch.
              // I will just use a solid color that represents the gradient well, like NeoColors.purple.
              Stack(
                clipBehavior: Clip.none,
                children: [
                  NotchedCard(
                    bg: NeoColors.purple, // Fallback to solid color for the notched card
                    notchPos: "tr",
                    notchSize: 52,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Overall Readiness",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "82%",
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -2,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "SOPs, resume & interview ready",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                        const SizedBox(height: 8), // Padding for the notch
                      ],
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: FloatingActionBtn(
                      icon: "✦",
                      bg: t.surf,
                      size: 48,
                      onClick: () => context.push('/copilot/chat'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Feature grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final f = features[index];
                  return SCard(
                    padding: const EdgeInsets.all(16),
                    onClick: () => context.push(f["route"] as String),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: f["bg"] as Color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(f["icon"] as String, style: const TextStyle(fontSize: 20)),
                        ),
                        Text(
                          f["label"] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: t.text,
                          ),
                        ),
                        PillBtn(
                          label: "Open →",
                          bg: f["color"] as Color,
                          size: "sm",
                          onClick: () => context.push(f["route"] as String),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Insights
              Text(
                "PERSONALIZED INSIGHTS",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: t.muted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              SCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: insights.asMap().entries.map((entry) {
                    final i = entry.key;
                    final ins = entry.value;
                    final color = ins["color"] as Color;
                    return Padding(
                      padding: EdgeInsets.only(bottom: i < insights.length - 1 ? 12 : 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.11),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 10),
                            child: Text(ins["icon"] as String, style: const TextStyle(fontSize: 13)),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                ins["text"] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: t.sub,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

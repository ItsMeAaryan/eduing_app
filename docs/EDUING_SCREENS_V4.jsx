import { useState, useEffect } from "react";

const G = {
  green: "#3DFF54",
  black: "#0A0A0A",
  black2: "#111111",
  surface: "#1A1A1A",
  surface2: "#222222",
  border: "#2A2A2A",
  white: "#FFFFFF",
  white60: "rgba(255,255,255,0.6)",
  white30: "rgba(255,255,255,0.3)",
  white10: "rgba(255,255,255,0.08)",
  purple: "#7B5EA7",
  blue: "#3B5BFF",
  orange: "#FF6B35",
  yellow: "#F5A623",
  red: "#FF3B30",
  pink: "#FF3B7A",
};

// ── SHARED ─────────────────────────────────────────────────────
function Badge({ label, color = G.green }) {
  return (
    <div style={{ display: "inline-flex", alignItems: "center", height: 20, padding: "0 8px", borderRadius: 10, background: color + "22", border: `1px solid ${color}44` }}>
      <span style={{ fontSize: 9, fontWeight: 900, color, letterSpacing: "0.08em" }}>{label}</span>
    </div>
  );
}

function ProgressBar({ value, color = G.green, height = 4 }) {
  return (
    <div style={{ height, borderRadius: height / 2, background: G.border, overflow: "hidden" }}>
      <div style={{ height: "100%", width: `${value}%`, borderRadius: height / 2, background: color, boxShadow: `0 0 8px ${color}55`, transition: "width 0.5s" }} />
    </div>
  );
}

function NotchedCard({ children, bg = G.surface, notchColor = G.black, actionIcon, actionBg = G.green, actionColor = G.black, style = {}, onAction }) {
  const [p, setP] = useState(false);
  return (
    <div style={{ position: "relative", ...style }}>
      <div style={{ background: bg, borderRadius: 20, padding: "18px", position: "relative", overflow: "hidden", boxShadow: "0 8px 24px rgba(0,0,0,0.4)" }}>
        {children}
        <div style={{ position: "absolute", bottom: -20, right: -20, width: 52, height: 52, borderRadius: "50%", background: notchColor }} />
      </div>
      {actionIcon && (
        <div onMouseDown={() => setP(true)} onMouseUp={() => setP(false)} onClick={onAction}
          style={{ position: "absolute", bottom: -10, right: -10, width: 44, height: 44, borderRadius: 22, background: actionBg, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 18, cursor: "pointer", zIndex: 10, boxShadow: `0 6px 20px ${actionBg}55`, transform: p ? "scale(0.9)" : "scale(1)", transition: "transform 0.1s", color: actionColor, fontWeight: 900 }}>
          {actionIcon}
        </div>
      )}
    </div>
  );
}

function FloatingNav({ active, onChange }) {
  const tabs = [{ id: "home", icon: "⊞", label: "Home" }, { id: "uni", icon: "🏛", label: "Discover" }, { id: "apps", icon: "📋", label: "Apply" }, { id: "ai", icon: "✦", label: "Copilot" }, { id: "plan", icon: "📅", label: "Planner" }];
  return (
    <div style={{ position: "absolute", bottom: 16, left: 16, right: 16, height: 62, background: "rgba(26,26,26,0.95)", backdropFilter: "blur(20px)", borderRadius: 31, border: `1px solid ${G.border}`, display: "flex", alignItems: "center", justifyContent: "space-around", padding: "0 6px", zIndex: 50, boxShadow: "0 8px 32px rgba(0,0,0,0.6)" }}>
      {tabs.map(t => {
        const on = t.id === active;
        return (
          <div key={t.id} onClick={() => onChange(t.id)} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 2, cursor: "pointer", padding: "6px 10px", borderRadius: 18, background: on ? "rgba(61,255,84,0.12)" : "transparent", transition: "all 0.2s", minWidth: 44 }}>
            <span style={{ fontSize: on ? 18 : 15, filter: on ? "none" : "grayscale(1) opacity(0.4)", transition: "all 0.2s" }}>{t.icon}</span>
            {on && <span style={{ fontSize: 8, fontWeight: 900, color: G.green, letterSpacing: "0.04em" }}>{t.label}</span>}
          </div>
        );
      })}
    </div>
  );
}

function StatusBar() {
  return (
    <div style={{ height: 40, display: "flex", alignItems: "center", justifyContent: "space-between", padding: "0 22px", flexShrink: 0 }}>
      <span style={{ fontSize: 13, fontWeight: 700, color: G.white }}>9:41</span>
      <div style={{ display: "flex", gap: 4, alignItems: "center" }}>
        {[0.4, 0.7, 1].map((o, i) => <div key={i} style={{ width: 3 + i * 0.5, height: 6 + i * 2, background: G.white, borderRadius: 1, opacity: o }} />)}
        <div style={{ width: 14, height: 7, border: `1.5px solid ${G.white}`, borderRadius: 3, marginLeft: 3, position: "relative", opacity: 0.8 }}>
          <div style={{ position: "absolute", left: 1, top: 1, right: 2, bottom: 1, background: G.white, borderRadius: 1 }} />
        </div>
      </div>
    </div>
  );
}

function BackHeader({ title, onBack, action }) {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "6px 18px 0", marginBottom: 4 }}>
      <div onClick={onBack} style={{ width: 32, height: 32, borderRadius: 16, background: G.surface, border: `1px solid ${G.border}`, display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer" }}>
        <span style={{ color: G.white, fontSize: 14 }}>←</span>
      </div>
      <span style={{ fontSize: 12, fontWeight: 800, color: G.white30, letterSpacing: "0.08em", flex: 1 }}>{title}</span>
      {action}
    </div>
  );
}

function GreenBtn({ label, onClick, icon, small = false, disabled = false }) {
  const [p, setP] = useState(false);
  return (
    <button onClick={onClick} disabled={disabled}
      onMouseDown={() => setP(true)} onMouseUp={() => setP(false)}
      style={{ height: small ? 38 : 52, padding: `0 ${small ? 16 : 24}px`, borderRadius: small ? 19 : 26, background: disabled ? "#2A2A2A" : G.green, color: disabled ? G.white30 : G.black, border: "none", fontSize: small ? 13 : 15, fontWeight: 800, cursor: disabled ? "not-allowed" : "pointer", display: "inline-flex", alignItems: "center", gap: 6, fontFamily: "inherit", transform: p ? "scale(0.96)" : "scale(1)", transition: "transform 0.1s", boxShadow: disabled ? "none" : `0 4px 20px ${G.green}44` }}>
      {icon && <span style={{ fontSize: small ? 14 : 17 }}>{icon}</span>}
      {label}
    </button>
  );
}

function Screen({ children, nav, setNav, showNav = true }) {
  return (
    <div style={{ height: "100%", background: G.black, display: "flex", flexDirection: "column", position: "relative" }}>
      <StatusBar />
      <div style={{ flex: 1, overflowY: "auto", paddingBottom: showNav ? 90 : 20 }}>
        {children}
      </div>
      {showNav && <FloatingNav active={nav} onChange={setNav} />}
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 1. PLANNER / JOURNEY SCREEN
// ══════════════════════════════════════════════════════════════
function PlannerScreen({ setNav, setScreen }) {
  const [view, setView] = useState("timeline");
  const milestones = [
    { label: "Research", done: true },
    { label: "Shortlist", done: true },
    { label: "Applications", done: false, active: true },
    { label: "Documents", done: false },
    { label: "Interviews", done: false },
    { label: "Offers", done: false },
  ];
  const tasks = [
    { title: "Upload Passport", tag: "REQUIRED", date: "Tomorrow", color: G.red, done: false },
    { title: "Finish BITS SOP", tag: "HIGH", date: "Jul 24", color: G.orange, done: false },
    { title: "Mock Interview Practice", tag: "MEDIUM", date: "Jul 24", color: G.blue, done: false },
    { title: "Stanford App Deadline", tag: "DEADLINE", date: "Jul 27", color: G.purple, done: true },
    { title: "STEM Grant Deadline", tag: "DEADLINE", date: "Jul 29", color: G.pink, done: false },
    { title: "IIT Bombay Application", tag: "IN PROGRESS", date: "Aug 15", color: G.green, done: false },
  ];
  const [done, setDone] = useState(tasks.map(t => t.done));

  return (
    <Screen nav="plan" setNav={setNav}>
      <div style={{ padding: "0 18px" }}>
        {/* Header */}
        <div style={{ paddingTop: 4, marginBottom: 18 }}>
          <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.12em", marginBottom: 3 }}>YOUR</div>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
            <div style={{ fontSize: 26, fontWeight: 900, color: G.white, letterSpacing: "-0.5px" }}>Planner</div>
            <GreenBtn label="+ Task" small onClick={() => { }} />
          </div>
        </div>

        {/* Journey milestone bar */}
        <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 20, padding: "16px", marginBottom: 18 }}>
          <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", marginBottom: 14 }}>ADMISSION JOURNEY</div>
          <div style={{ display: "flex", alignItems: "center", gap: 0 }}>
            {milestones.map((m, i) => (
              <div key={i} style={{ display: "flex", alignItems: "center", flex: 1 }}>
                <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}>
                  <div style={{
                    width: 32, height: 32, borderRadius: 16,
                    background: m.done ? G.green : m.active ? G.purple : G.surface2,
                    border: m.active ? `2px solid ${G.purple}` : m.done ? "none" : `2px solid ${G.border}`,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    fontSize: 14, boxShadow: m.active ? `0 0 16px ${G.purple}66` : m.done ? `0 0 8px ${G.green}44` : "none",
                    transition: "all 0.3s",
                  }}>
                    {m.done ? "✓" : m.active ? "⟳" : ""}
                  </div>
                  <span style={{ fontSize: 8, fontWeight: 800, color: m.done ? G.green : m.active ? G.purple : G.white30, textAlign: "center", letterSpacing: "0.03em", whiteSpace: "nowrap" }}>{m.label}</span>
                </div>
                {i < milestones.length - 1 && (
                  <div style={{ flex: 1, height: 2, background: m.done ? G.green : G.border, margin: "0 4px", marginBottom: 20, transition: "background 0.3s", boxShadow: m.done ? `0 0 6px ${G.green}66` : "none" }} />
                )}
              </div>
            ))}
          </div>
        </div>

        {/* AI Copilot suggestion */}
        <div onClick={() => setScreen("copilot")} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", marginBottom: 18, background: G.green + "14", border: `1.5px solid ${G.green}33`, borderRadius: 16, cursor: "pointer" }}>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: G.green, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16, flexShrink: 0 }}>✦</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 800, color: G.white }}>Copilot Suggestion</div>
            <div style={{ fontSize: 12, color: G.white30, marginTop: 1 }}>Finish SOP before Friday · High priority</div>
          </div>
          <span style={{ color: G.green, fontSize: 16 }}>→</span>
        </div>

        {/* View toggle */}
        <div style={{ display: "flex", gap: 6, marginBottom: 16, background: G.surface, borderRadius: 20, padding: 4 }}>
          {[["timeline", "Timeline"], ["calendar", "Calendar"]].map(([id, label]) => (
            <div key={id} onClick={() => setView(id)} style={{ flex: 1, height: 34, borderRadius: 17, display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", background: view === id ? G.green : "transparent", transition: "all 0.2s" }}>
              <span style={{ fontSize: 12, fontWeight: 800, color: view === id ? G.black : G.white30 }}>{label}</span>
            </div>
          ))}
        </div>

        {/* Task list */}
        <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", marginBottom: 12 }}>ACTION ITEMS</div>
        {tasks.map((task, i) => (
          <div key={i} onClick={() => setDone(p => { const n = [...p]; n[i] = !n[i]; return n; })} style={{
            display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", marginBottom: 10,
            background: G.surface, borderRadius: 16,
            border: `1px solid ${done[i] ? G.border : task.color + "22"}`,
            cursor: "pointer", opacity: done[i] ? 0.5 : 1,
            transition: "all 0.2s",
          }}>
            {/* Checkbox */}
            <div style={{ width: 22, height: 22, borderRadius: 11, border: `2px solid ${done[i] ? G.green : task.color}`, background: done[i] ? G.green : "transparent", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0, transition: "all 0.2s" }}>
              {done[i] && <span style={{ fontSize: 11, color: G.black, fontWeight: 900 }}>✓</span>}
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 800, color: G.white, textDecoration: done[i] ? "line-through" : "none" }}>{task.title}</div>
              <div style={{ fontSize: 11, color: G.white30, marginTop: 2 }}>📅 {task.date}</div>
            </div>
            <Badge label={task.tag} color={task.color} />
          </div>
        ))}
      </div>
    </Screen>
  );
}

// ══════════════════════════════════════════════════════════════
// 2. SOP BUILDER SCREEN (fixes /sop 404)
// ══════════════════════════════════════════════════════════════
function SOPScreen({ setScreen }) {
  const [step, setStep] = useState(1);
  const [uni, setUni] = useState("BITS Pilani");
  const [course, setCourse] = useState("B.Tech CSE");
  const [body, setBody] = useState("");
  const [loading, setLoading] = useState(false);
  const [generated, setGenerated] = useState(false);

  const sampleSOP = `I am a highly motivated student with a deep passion for computer science and artificial intelligence. Growing up in an environment that valued innovation, I developed an early interest in programming and problem-solving.

During my high school years, I consistently ranked in the top 1% of my class, achieving a JEE score that reflects both my dedication and aptitude for engineering. Beyond academics, I led my school's robotics team to the national finals.

BITS Pilani's unique dual-degree program and emphasis on practical industry exposure align perfectly with my goal of becoming an AI researcher who bridges the gap between theoretical advances and real-world impact.`;

  const generate = () => {
    setLoading(true);
    setTimeout(() => { setLoading(false); setGenerated(true); setBody(sampleSOP); setStep(3); }, 2000);
  };

  const steps = ["University", "Questionnaire", "Generated", "Review"];

  return (
    <div style={{ height: "100%", background: G.black, display: "flex", flexDirection: "column" }}>
      <StatusBar />
      <BackHeader title="SOP BUILDER" onBack={() => setScreen("copilot")}
        action={<Badge label={`STEP ${step}/4`} color={G.purple} />}
      />

      {/* Progress bar */}
      <div style={{ padding: "12px 18px 0" }}>
        <div style={{ display: "flex", gap: 4, marginBottom: 20 }}>
          {steps.map((_, i) => (
            <div key={i} style={{ flex: 1, height: 3, borderRadius: 2, background: i < step ? G.green : G.border, boxShadow: i < step ? `0 0 8px ${G.green}66` : "none", transition: "all 0.3s" }} />
          ))}
        </div>
      </div>

      <div style={{ flex: 1, overflowY: "auto", padding: "0 18px 24px" }}>

        {step === 1 && (
          <>
            <h2 style={{ fontSize: 24, fontWeight: 900, color: G.white, letterSpacing: "-0.5px", marginBottom: 6 }}>Choose university.</h2>
            <p style={{ fontSize: 13, color: G.white30, marginBottom: 24 }}>AI will tailor your SOP for the specific program.</p>
            {["BITS Pilani", "IIT Bombay", "Delhi University", "VIT Vellore"].map(u => (
              <div key={u} onClick={() => setUni(u)} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", marginBottom: 10, background: G.surface, borderRadius: 16, border: `1.5px solid ${uni === u ? G.green : G.border}`, cursor: "pointer", boxShadow: uni === u ? `0 0 16px ${G.green}22` : "none", transition: "all 0.2s" }}>
                <div style={{ width: 36, height: 36, borderRadius: 12, background: uni === u ? G.green + "22" : G.surface2, border: `1px solid ${uni === u ? G.green : G.border}`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16 }}>🏛</div>
                <span style={{ fontSize: 14, fontWeight: 800, color: uni === u ? G.green : G.white }}>{u}</span>
                {uni === u && <span style={{ marginLeft: "auto", color: G.green, fontSize: 18 }}>✓</span>}
              </div>
            ))}
            <div style={{ marginTop: 8 }}>
              <GreenBtn label="Continue →" onClick={() => setStep(2)} style={{ width: "100%" }} />
            </div>
          </>
        )}

        {step === 2 && (
          <>
            <h2 style={{ fontSize: 24, fontWeight: 900, color: G.white, letterSpacing: "-0.5px", marginBottom: 6 }}>Tell AI about you.</h2>
            <p style={{ fontSize: 13, color: G.white30, marginBottom: 24 }}>Answer a few questions to generate a personalised SOP.</p>
            {[
              { q: "Why this university and course?", ph: "What draws you to BITS Pilani CSE..." },
              { q: "Your biggest academic achievement?", ph: "JEE rank, projects, competitions..." },
              { q: "Career goal in 10 years?", ph: "AI researcher, startup founder, engineer..." },
              { q: "Extra-curriculars or leadership?", ph: "Robotics team, coding club, sports..." },
            ].map((item, i) => (
              <div key={i} style={{ marginBottom: 16 }}>
                <div style={{ fontSize: 11, fontWeight: 800, color: G.white30, letterSpacing: "0.06em", marginBottom: 6 }}>{item.q.toUpperCase()}</div>
                <textarea placeholder={item.ph}
                  style={{ width: "100%", minHeight: 72, background: G.surface, border: `1.5px solid ${G.border}`, borderRadius: 14, padding: "12px 14px", fontSize: 13, color: G.white, outline: "none", fontFamily: "inherit", resize: "vertical", boxSizing: "border-box", lineHeight: 1.5 }} />
              </div>
            ))}
            <GreenBtn label={loading ? "Generating..." : "✦ Generate SOP"} onClick={generate} disabled={loading} />
          </>
        )}

        {step === 3 && generated && (
          <>
            <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 16 }}>
              <div style={{ width: 36, height: 36, borderRadius: 12, background: G.green, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16 }}>✦</div>
              <div>
                <div style={{ fontSize: 14, fontWeight: 800, color: G.white }}>SOP Generated</div>
                <div style={{ fontSize: 11, color: G.white30 }}>AI-crafted for {uni} · {course}</div>
              </div>
              <Badge label="88% MATCH" color={G.green} style={{ marginLeft: "auto" }} />
            </div>

            {/* Score bar */}
            <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, padding: "14px 16px", marginBottom: 16 }}>
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 8 }}>
                <span style={{ fontSize: 12, fontWeight: 800, color: G.white60 }}>Quality Score</span>
                <span style={{ fontSize: 14, fontWeight: 900, color: G.green }}>88/100</span>
              </div>
              <ProgressBar value={88} color={G.green} height={5} />
              <div style={{ display: "flex", gap: 8, marginTop: 10, flexWrap: "wrap" }}>
                {[["Clarity", "92%", G.green], ["Relevance", "85%", G.blue], ["Tone", "88%", G.purple]].map(([l, v, c]) => (
                  <div key={l} style={{ background: c + "18", border: `1px solid ${c}33`, borderRadius: 10, padding: "4px 10px" }}>
                    <span style={{ fontSize: 10, fontWeight: 800, color: c }}>{l}: {v}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* SOP Text */}
            <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, padding: "16px", marginBottom: 16 }}>
              <textarea value={body} onChange={e => setBody(e.target.value)}
                style={{ width: "100%", minHeight: 200, background: "transparent", border: "none", fontSize: 13, color: G.white60, outline: "none", fontFamily: "inherit", resize: "vertical", lineHeight: 1.7, boxSizing: "border-box" }} />
            </div>

            <div style={{ display: "flex", gap: 10 }}>
              <GreenBtn label="✦ Improve" onClick={() => { }} small />
              <GreenBtn label="📋 Copy" onClick={() => navigator.clipboard?.writeText(body)} small />
              <GreenBtn label="Save →" onClick={() => setStep(4)} small />
            </div>
          </>
        )}

        {step === 4 && (
          <>
            <div style={{ textAlign: "center", padding: "40px 0" }}>
              <div style={{ fontSize: 64, marginBottom: 16 }}>🎉</div>
              <div style={{ fontSize: 24, fontWeight: 900, color: G.white, marginBottom: 8 }}>SOP Saved!</div>
              <div style={{ fontSize: 14, color: G.white30, marginBottom: 28 }}>Your SOP for {uni} has been saved to your vault.</div>
              <GreenBtn label="Back to Copilot" onClick={() => setScreen("copilot")} />
            </div>
          </>
        )}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 3. RESUME BUILDER (fixes /resume 404)
// ══════════════════════════════════════════════════════════════
function ResumeScreen({ setScreen }) {
  const [atsScore] = useState(78);
  const sections = [
    { icon: "👤", label: "Personal Info", done: true, color: G.green },
    { icon: "📚", label: "Education", done: true, color: G.green },
    { icon: "💼", label: "Experience", done: false, color: G.yellow },
    { icon: "🔧", label: "Skills", done: true, color: G.green },
    { icon: "🏆", label: "Achievements", done: false, color: G.orange },
    { icon: "📋", label: "Projects", done: false, color: G.blue },
    { icon: "🌐", label: "Links & Socials", done: false, color: G.purple },
  ];

  return (
    <div style={{ height: "100%", background: G.black, display: "flex", flexDirection: "column" }}>
      <StatusBar />
      <BackHeader title="RESUME BUILDER" onBack={() => setScreen("copilot")}
        action={<GreenBtn label="Export" small onClick={() => { }} />}
      />

      <div style={{ flex: 1, overflowY: "auto", padding: "16px 18px 24px" }}>

        {/* ATS Score hero */}
        <NotchedCard bg={`linear-gradient(135deg,${G.blue},${G.purple})`} notchColor={G.black} actionIcon="✦" actionBg={G.green} actionColor={G.black} style={{ marginBottom: 18 }}>
          <div style={{ fontSize: 10, fontWeight: 800, color: "rgba(255,255,255,0.5)", letterSpacing: "0.1em", marginBottom: 6 }}>ATS SCORE</div>
          <div style={{ fontSize: 52, fontWeight: 900, color: "#fff", letterSpacing: "-2px", lineHeight: 1, marginBottom: 6 }}>{atsScore}</div>
          <div style={{ fontSize: 13, color: "rgba(255,255,255,0.6)", marginBottom: 14 }}>Good — 3 improvements suggested</div>
          <ProgressBar value={atsScore} color="rgba(255,255,255,0.9)" height={4} />
          <div style={{ display: "flex", gap: 8, marginTop: 10, flexWrap: "wrap" }}>
            {[["Keywords", "82%", "#fff"], ["Format", "90%", "#fff"], ["Length", "65%", "#FFD700"]].map(([l, v, c]) => (
              <div key={l} style={{ background: "rgba(255,255,255,0.12)", borderRadius: 10, padding: "4px 10px" }}>
                <span style={{ fontSize: 10, fontWeight: 800, color: c }}>{l}: {v}</span>
              </div>
            ))}
          </div>
        </NotchedCard>

        {/* AI suggestions */}
        <div style={{ background: G.surface, border: `1px solid ${G.yellow}22`, borderRadius: 16, padding: "14px 16px", marginBottom: 18 }}>
          <div style={{ fontSize: 10, fontWeight: 800, color: G.yellow, letterSpacing: "0.08em", marginBottom: 10 }}>AI IMPROVEMENTS</div>
          {[
            "Add 3 more relevant keywords: 'machine learning', 'Python', 'data structures'",
            "Expand your Projects section — ATS rewards detailed descriptions",
            "Add quantified achievements: 'Led team of 5', 'Improved X by 40%'",
          ].map((tip, i) => (
            <div key={i} style={{ display: "flex", gap: 10, alignItems: "flex-start", marginBottom: i < 2 ? 10 : 0 }}>
              <div style={{ width: 20, height: 20, borderRadius: 10, background: G.yellow + "22", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 10, flexShrink: 0, marginTop: 1 }}>⚡</div>
              <span style={{ fontSize: 12, color: G.white60, lineHeight: 1.45 }}>{tip}</span>
            </div>
          ))}
        </div>

        {/* Resume sections */}
        <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", marginBottom: 12 }}>RESUME SECTIONS</div>
        {sections.map((s, i) => (
          <div key={i} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", marginBottom: 10, background: G.surface, borderRadius: 16, border: `1px solid ${s.done ? s.color + "22" : G.border}`, cursor: "pointer" }}>
            <div style={{ width: 40, height: 40, borderRadius: 14, background: s.color + "18", border: `1px solid ${s.color}33`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 18, flexShrink: 0 }}>{s.icon}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 800, color: G.white }}>{s.label}</div>
              <div style={{ fontSize: 11, color: s.done ? G.green : G.white30, marginTop: 1 }}>{s.done ? "Completed" : "Not filled"}</div>
            </div>
            <div style={{ width: 28, height: 28, borderRadius: 14, background: s.done ? G.green + "22" : G.surface2, border: `1.5px solid ${s.done ? G.green : G.border}`, display: "flex", alignItems: "center", justifyContent: "center" }}>
              <span style={{ fontSize: 12, color: s.done ? G.green : G.white30, fontWeight: 900 }}>{s.done ? "✓" : "+"}</span>
            </div>
          </div>
        ))}

        {/* Template picker */}
        <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", margin: "16px 0 12px" }}>TEMPLATES</div>
        <div style={{ display: "flex", gap: 10 }}>
          {[{ name: "Minimal", color: G.white }, { name: "Bold", color: G.green }, { name: "Classic", color: G.blue }].map((t, i) => (
            <div key={i} style={{ flex: 1, height: 60, background: G.surface, border: `1.5px solid ${i === 1 ? G.green : G.border}`, borderRadius: 14, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", cursor: "pointer", gap: 4 }}>
              <div style={{ width: 24, height: 4, borderRadius: 2, background: t.color, opacity: 0.6 }} />
              <div style={{ width: 16, height: 3, borderRadius: 2, background: t.color, opacity: 0.3 }} />
              <span style={{ fontSize: 9, fontWeight: 800, color: i === 1 ? G.green : G.white30, marginTop: 2 }}>{t.name}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 4. MOCK INTERVIEW SCREEN
// ══════════════════════════════════════════════════════════════
function InterviewScreen({ setScreen }) {
  const [phase, setPhase] = useState("home"); // home | prep | active | feedback
  const [timer, setTimer] = useState(120);
  const [recording, setRecording] = useState(false);
  const [qIdx, setQIdx] = useState(0);

  const questions = [
    "Tell me about yourself and why you chose computer science.",
    "What is your greatest academic achievement and what did you learn?",
    "Where do you see yourself in 10 years?",
    "Why specifically BITS Pilani over other top universities?",
    "Describe a challenge you overcame and how.",
  ];

  useEffect(() => {
    if (phase !== "active" || !recording) return;
    if (timer <= 0) { setRecording(false); setPhase("feedback"); return; }
    const t = setInterval(() => setTimer(v => v - 1), 1000);
    return () => clearInterval(t);
  }, [phase, recording, timer]);

  const formatTime = (s) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;

  return (
    <div style={{ height: "100%", background: G.black, display: "flex", flexDirection: "column" }}>
      <StatusBar />
      <BackHeader title="MOCK INTERVIEW" onBack={() => phase === "home" ? setScreen("copilot") : setPhase("home")} />

      <div style={{ flex: 1, overflowY: "auto", padding: "16px 18px 24px" }}>

        {phase === "home" && (
          <>
            {/* Hero */}
            <NotchedCard bg={`linear-gradient(135deg,#1C8A5E,${G.blue})`} notchColor={G.black} actionIcon="▶" actionBg={G.green} actionColor={G.black} style={{ marginBottom: 18 }} onAction={() => setPhase("prep")}>
              <div style={{ fontSize: 10, fontWeight: 800, color: "rgba(255,255,255,0.5)", letterSpacing: "0.1em", marginBottom: 6 }}>AI VIDEO & AUDIO PRACTICE</div>
              <div style={{ fontSize: 22, fontWeight: 900, color: "#fff", letterSpacing: "-0.5px", lineHeight: 1.2, marginBottom: 8 }}>Practice admission{"\n"}& visa interviews.</div>
              <div style={{ fontSize: 13, color: "rgba(255,255,255,0.6)" }}>AI grades clarity, structure & delivery instantly.</div>
            </NotchedCard>

            {/* Stats */}
            <div style={{ display: "flex", gap: 10, marginBottom: 18 }}>
              {[{ label: "Sessions", value: "3", color: G.green }, { label: "Avg Score", value: "74%", color: G.blue }, { label: "Questions", value: "12", color: G.purple }].map(s => (
                <div key={s.label} style={{ flex: 1, background: G.surface, border: `1px solid ${s.color}22`, borderRadius: 14, padding: "12px 10px" }}>
                  <div style={{ fontSize: 8, fontWeight: 800, color: G.white30, letterSpacing: "0.06em", marginBottom: 4 }}>{s.label.toUpperCase()}</div>
                  <div style={{ fontSize: 22, fontWeight: 900, color: s.color }}>{s.value}</div>
                </div>
              ))}
            </div>

            {/* Question categories */}
            <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", marginBottom: 12 }}>PRACTICE BY CATEGORY</div>
            {[
              { icon: "🎓", label: "University Admission", count: 24, color: G.purple },
              { icon: "🌍", label: "Visa Interview", count: 18, color: G.blue },
              { icon: "💼", label: "HR & Behavioral", count: 30, color: G.orange },
              { icon: "🔬", label: "Technical CS", count: 40, color: G.green },
            ].map((c, i) => (
              <div key={i} onClick={() => setPhase("prep")} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", marginBottom: 10, background: G.surface, border: `1px solid ${c.color}22`, borderRadius: 16, cursor: "pointer" }}>
                <div style={{ width: 42, height: 42, borderRadius: 14, background: c.color + "18", border: `1px solid ${c.color}33`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 20, flexShrink: 0 }}>{c.icon}</div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14, fontWeight: 800, color: G.white }}>{c.label}</div>
                  <div style={{ fontSize: 11, color: G.white30 }}>{c.count} questions</div>
                </div>
                <span style={{ color: G.white30, fontSize: 16 }}>›</span>
              </div>
            ))}
          </>
        )}

        {phase === "prep" && (
          <>
            <h2 style={{ fontSize: 22, fontWeight: 900, color: G.white, letterSpacing: "-0.5px", marginBottom: 6 }}>Ready to start?</h2>
            <p style={{ fontSize: 13, color: G.white30, marginBottom: 20 }}>{questions.length} questions · ~10 minutes · AI graded</p>
            <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, padding: "16px", marginBottom: 20 }}>
              <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.08em", marginBottom: 10 }}>TIPS</div>
              {["Speak clearly and maintain eye contact with camera", "Structure answers: Situation → Action → Result", "Take 5 seconds to think before answering"].map((t, i) => (
                <div key={i} style={{ display: "flex", gap: 10, marginBottom: i < 2 ? 10 : 0 }}>
                  <span style={{ color: G.green, fontWeight: 900, fontSize: 13 }}>✓</span>
                  <span style={{ fontSize: 13, color: G.white60 }}>{t}</span>
                </div>
              ))}
            </div>
            <GreenBtn label="▶ Start Interview" onClick={() => { setPhase("active"); setTimer(120); setQIdx(0); }} />
          </>
        )}

        {phase === "active" && (
          <>
            {/* Camera viewfinder */}
            <div style={{ width: "100%", height: 180, background: G.surface2, borderRadius: 20, border: `2px solid ${recording ? G.green : G.border}`, display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 16, position: "relative", boxShadow: recording ? `0 0 24px ${G.green}33` : "none", transition: "all 0.3s" }}>
              <span style={{ fontSize: 48 }}>📷</span>
              {recording && (
                <div style={{ position: "absolute", top: 12, right: 12, display: "flex", alignItems: "center", gap: 6, background: "rgba(255,0,0,0.8)", borderRadius: 10, padding: "4px 10px" }}>
                  <div style={{ width: 6, height: 6, borderRadius: 3, background: "#fff", animation: "blink 1s infinite" }} />
                  <span style={{ fontSize: 10, fontWeight: 800, color: "#fff" }}>REC {formatTime(timer)}</span>
                </div>
              )}
            </div>

            {/* Question */}
            <div style={{ background: G.surface, border: `1px solid ${G.purple}33`, borderRadius: 16, padding: "16px", marginBottom: 16 }}>
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 8 }}>
                <Badge label={`Q${qIdx + 1}/${questions.length}`} color={G.purple} />
                <span style={{ fontSize: 12, fontWeight: 800, color: G.white30 }}>{formatTime(timer)}</span>
              </div>
              <div style={{ fontSize: 15, fontWeight: 700, color: G.white, lineHeight: 1.5 }}>{questions[qIdx]}</div>
            </div>

            <div style={{ display: "flex", gap: 10 }}>
              <div onClick={() => setRecording(!recording)} style={{ flex: 1, height: 52, borderRadius: 26, background: recording ? G.red : G.green, display: "flex", alignItems: "center", justifyContent: "center", gap: 8, cursor: "pointer", boxShadow: `0 4px 20px ${recording ? G.red : G.green}44` }}>
                <span style={{ fontSize: 18 }}>{recording ? "⏹" : "🎤"}</span>
                <span style={{ fontSize: 14, fontWeight: 800, color: recording ? G.white : G.black }}>{recording ? "Stop" : "Record"}</span>
              </div>
              {qIdx < questions.length - 1 ? (
                <div onClick={() => { setQIdx(i => i + 1); setTimer(120); setRecording(false); }} style={{ height: 52, padding: "0 20px", borderRadius: 26, background: G.surface, border: `1px solid ${G.border}`, display: "flex", alignItems: "center", cursor: "pointer" }}>
                  <span style={{ fontSize: 13, fontWeight: 800, color: G.white60 }}>Skip →</span>
                </div>
              ) : (
                <div onClick={() => setPhase("feedback")} style={{ height: 52, padding: "0 20px", borderRadius: 26, background: G.purple, display: "flex", alignItems: "center", cursor: "pointer" }}>
                  <span style={{ fontSize: 13, fontWeight: 800, color: "#fff" }}>Finish</span>
                </div>
              )}
            </div>
          </>
        )}

        {phase === "feedback" && (
          <>
            <div style={{ textAlign: "center", marginBottom: 24 }}>
              <div style={{ fontSize: 52, marginBottom: 8 }}>🎯</div>
              <div style={{ fontSize: 22, fontWeight: 900, color: G.white, marginBottom: 4 }}>Interview Complete!</div>
              <div style={{ fontSize: 13, color: G.white30 }}>AI has analysed your responses</div>
            </div>

            <NotchedCard bg={`linear-gradient(135deg,#1C8A5E,${G.blue})`} notchColor={G.black} actionIcon="✦" actionBg={G.green} actionColor={G.black} style={{ marginBottom: 18 }}>
              <div style={{ fontSize: 10, fontWeight: 800, color: "rgba(255,255,255,0.5)", letterSpacing: "0.1em", marginBottom: 6 }}>OVERALL SCORE</div>
              <div style={{ fontSize: 52, fontWeight: 900, color: "#fff", letterSpacing: "-2px", lineHeight: 1, marginBottom: 12 }}>76%</div>
              <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                {[["Clarity", "80%"], ["Structure", "72%"], ["Delivery", "75%"], ["Relevance", "78%"]].map(([l, v]) => (
                  <div key={l} style={{ background: "rgba(255,255,255,0.15)", borderRadius: 10, padding: "4px 10px" }}>
                    <span style={{ fontSize: 10, fontWeight: 800, color: "#fff" }}>{l}: {v}</span>
                  </div>
                ))}
              </div>
            </NotchedCard>

            {[
              { icon: "✅", text: "Strong opening — good structure on Q1 & Q3", color: G.green },
              { icon: "⚠️", text: "Improve: Use specific examples with data/numbers", color: G.yellow },
              { icon: "💡", text: "Tip: Practice the STAR method for Q4", color: G.blue },
            ].map((fb, i) => (
              <div key={i} style={{ display: "flex", gap: 10, padding: "12px 14px", marginBottom: 10, background: G.surface, border: `1px solid ${fb.color}22`, borderRadius: 14 }}>
                <span style={{ fontSize: 16 }}>{fb.icon}</span>
                <span style={{ fontSize: 13, color: G.white60, lineHeight: 1.4 }}>{fb.text}</span>
              </div>
            ))}
            <div style={{ marginTop: 8 }}>
              <GreenBtn label="Practice Again" onClick={() => { setPhase("home"); setTimer(120); setQIdx(0); setRecording(false); }} />
            </div>
          </>
        )}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 5. SCHOLARSHIPS SCREEN
// ══════════════════════════════════════════════════════════════
function ScholarshipsScreen({ setNav }) {
  const [filter, setFilter] = useState("All");
  const scholarships = [
    { name: "STEM Innovators Grant", org: "Govt of India", amount: "₹2L", match: 94, deadline: "Jul 29", color: G.green, type: "Government" },
    { name: "Merit Excellence Fund", org: "BITS Foundation", amount: "₹1.5L", match: 87, deadline: "Aug 10", color: G.purple, type: "Private" },
    { name: "National Science Talent", org: "DST India", amount: "₹50K", match: 79, deadline: "Aug 20", color: G.blue, type: "Government" },
    { name: "Women in Tech Award", org: "Google India", amount: "₹3L", match: 72, deadline: "Sep 1", color: G.pink, type: "Corporate" },
    { name: "Sports Excellence Grant", org: "SAI", amount: "₹75K", match: 65, deadline: "Sep 15", color: G.orange, type: "Government" },
  ];
  const filters = ["All", "Government", "Private", "Corporate", "Need-Based"];
  const filtered = filter === "All" ? scholarships : scholarships.filter(s => s.type === filter);

  return (
    <Screen nav="home" setNav={setNav}>
      <div style={{ padding: "0 18px" }}>
        <div style={{ paddingTop: 4, marginBottom: 18 }}>
          <div style={{ fontSize: 10, fontWeight: 800, color: G.yellow, letterSpacing: "0.12em", marginBottom: 3 }}>FINANCIAL AID</div>
          <div style={{ fontSize: 26, fontWeight: 900, color: G.white, letterSpacing: "-0.5px" }}>Scholarships</div>
        </div>

        {/* Hero */}
        <NotchedCard bg={`linear-gradient(135deg,${G.yellow}CC,${G.orange})`} notchColor={G.black} actionIcon="→" actionBg={G.black} actionColor={G.white} style={{ marginBottom: 18 }}>
          <div style={{ fontSize: 10, fontWeight: 800, color: "rgba(0,0,0,0.5)", letterSpacing: "0.1em", marginBottom: 6 }}>AI MATCHED FOR YOU</div>
          <div style={{ fontSize: 32, fontWeight: 900, color: G.black, letterSpacing: "-1px", lineHeight: 1.1, marginBottom: 6 }}>5 scholarships{"\n"}worth ₹8.25L</div>
          <div style={{ fontSize: 13, color: "rgba(0,0,0,0.6)" }}>Based on your profile & eligibility</div>
        </NotchedCard>

        {/* Filter chips */}
        <div style={{ display: "flex", gap: 8, marginBottom: 18, overflowX: "auto", paddingBottom: 4 }}>
          {filters.map(f => (
            <div key={f} onClick={() => setFilter(f)} style={{ height: 32, padding: "0 14px", borderRadius: 16, cursor: "pointer", background: filter === f ? G.yellow : G.surface, border: `1.5px solid ${filter === f ? G.yellow : G.border}`, display: "flex", alignItems: "center", whiteSpace: "nowrap", transition: "all 0.2s" }}>
              <span style={{ fontSize: 12, fontWeight: 800, color: filter === f ? G.black : G.white60 }}>{f}</span>
            </div>
          ))}
        </div>

        {/* Scholarship cards */}
        {filtered.map((s, i) => (
          <NotchedCard key={i} bg={G.surface} notchColor={G.black} actionIcon="→" actionBg={s.color} actionColor={s.color === G.yellow ? G.black : G.white} style={{ marginBottom: 14 }}>
            <div style={{ display: "flex", alignItems: "flex-start", gap: 12, marginBottom: 12 }}>
              <div style={{ width: 44, height: 44, borderRadius: 14, background: s.color + "18", border: `1.5px solid ${s.color}33`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 20, flexShrink: 0 }}>🏆</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 900, color: G.white, marginBottom: 2 }}>{s.name}</div>
                <div style={{ fontSize: 11, color: G.white30 }}>{s.org}</div>
              </div>
              <div style={{ textAlign: "right" }}>
                <div style={{ fontSize: 16, fontWeight: 900, color: s.color }}>{s.amount}</div>
                <div style={{ fontSize: 10, color: G.white30 }}>per year</div>
              </div>
            </div>
            <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
              <ProgressBar value={s.match} color={s.color} height={4} />
              <span style={{ fontSize: 11, fontWeight: 900, color: s.color, whiteSpace: "nowrap" }}>{s.match}% match</span>
            </div>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <div style={{ display: "flex", gap: 6 }}>
                <Badge label={s.type} color={s.color} />
                <Badge label={`Due ${s.deadline}`} color={G.white30} />
              </div>
            </div>
          </NotchedCard>
        ))}
      </div>
    </Screen>
  );
}

// ══════════════════════════════════════════════════════════════
// 6. UNIVERSITY DETAIL SCREEN
// ══════════════════════════════════════════════════════════════
function UniDetailScreen({ setScreen }) {
  const [tab, setTab] = useState("overview");
  const tabs = ["overview", "courses", "placements", "reviews"];

  return (
    <div style={{ height: "100%", background: G.black, display: "flex", flexDirection: "column" }}>
      <StatusBar />
      <BackHeader title="UNIVERSITY DETAIL" onBack={() => setScreen("discover")}
        action={<div style={{ width: 32, height: 32, borderRadius: 16, background: G.surface, border: `1px solid ${G.border}`, display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", fontSize: 15 }}>🔖</div>}
      />

      <div style={{ flex: 1, overflowY: "auto", padding: "0 0 24px" }}>
        {/* Hero */}
        <div style={{ padding: "16px 18px 0" }}>
          <div style={{ width: "100%", height: 140, background: `linear-gradient(135deg,${G.purple}44,${G.blue}44)`, borderRadius: 20, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 64, marginBottom: 16, border: `1px solid ${G.purple}33` }}>🏛</div>

          <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between", marginBottom: 14 }}>
            <div>
              <div style={{ fontSize: 22, fontWeight: 900, color: G.white, letterSpacing: "-0.5px" }}>BITS Pilani</div>
              <div style={{ fontSize: 13, color: G.white30, marginTop: 2 }}>📍 Pilani, Rajasthan · Est. 1964</div>
            </div>
            <Badge label="NIRF #1" color={G.green} />
          </div>

          {/* Quick stats */}
          <div style={{ display: "flex", gap: 8, marginBottom: 16 }}>
            {[{ label: "Match", value: "96%", color: G.green }, { label: "Fees", value: "₹18L", color: G.blue }, { label: "Seats", value: "120", color: G.purple }, { label: "Cutoff", value: "260", color: G.orange }].map(s => (
              <div key={s.label} style={{ flex: 1, background: G.surface, border: `1px solid ${s.color}22`, borderRadius: 12, padding: "10px 6px", textAlign: "center" }}>
                <div style={{ fontSize: 14, fontWeight: 900, color: s.color }}>{s.value}</div>
                <div style={{ fontSize: 9, fontWeight: 800, color: G.white30, marginTop: 2, letterSpacing: "0.04em" }}>{s.label.toUpperCase()}</div>
              </div>
            ))}
          </div>

          {/* Apply CTA */}
          <div style={{ display: "flex", gap: 10, marginBottom: 18 }}>
            <div style={{ flex: 1, height: 48, borderRadius: 24, background: G.green, display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", boxShadow: `0 4px 20px ${G.green}44` }}>
              <span style={{ fontSize: 14, fontWeight: 800, color: G.black }}>Apply Now →</span>
            </div>
            <div style={{ width: 48, height: 48, borderRadius: 24, background: G.surface, border: `1px solid ${G.border}`, display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", fontSize: 18 }}>📤</div>
          </div>
        </div>

        {/* Tab switcher */}
        <div style={{ display: "flex", gap: 0, padding: "0 18px", marginBottom: 18, overflowX: "auto" }}>
          {tabs.map(t => (
            <div key={t} onClick={() => setTab(t)} style={{ height: 36, padding: "0 16px", cursor: "pointer", borderBottom: `2px solid ${tab === t ? G.green : "transparent"}`, display: "flex", alignItems: "center", whiteSpace: "nowrap", transition: "all 0.2s" }}>
              <span style={{ fontSize: 12, fontWeight: 800, color: tab === t ? G.green : G.white30, textTransform: "capitalize" }}>{t}</span>
            </div>
          ))}
        </div>

        {/* Tab content */}
        <div style={{ padding: "0 18px" }}>
          {tab === "overview" && (
            <>
              <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, padding: "16px", marginBottom: 14 }}>
                <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.08em", marginBottom: 10 }}>ABOUT</div>
                <div style={{ fontSize: 13, color: G.white60, lineHeight: 1.6 }}>Birla Institute of Technology and Science, Pilani is a private deemed university known for its rigorous engineering programs, research culture, and strong industry connections. Consistently ranked #1 among private universities in India.</div>
              </div>
              {[
                { label: "Accreditation", value: "NAAC A++ · NBA Accredited", icon: "🏅", color: G.green },
                { label: "Intake Season", value: "July–August (JEE + BITSAT)", icon: "📅", color: G.blue },
                { label: "Placement Rate", value: "95% placed · Avg ₹18 LPA", icon: "💼", color: G.purple },
                { label: "Campus Size", value: "1,095 acres · 4 campuses", icon: "🌳", color: G.orange },
              ].map((item, i) => (
                <div key={i} style={{ display: "flex", alignItems: "center", gap: 12, padding: "12px 14px", marginBottom: 10, background: G.surface, border: `1px solid ${item.color}22`, borderRadius: 14 }}>
                  <div style={{ width: 36, height: 36, borderRadius: 12, background: item.color + "18", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16, flexShrink: 0 }}>{item.icon}</div>
                  <div>
                    <div style={{ fontSize: 11, color: G.white30, fontWeight: 700 }}>{item.label}</div>
                    <div style={{ fontSize: 13, color: G.white, fontWeight: 700, marginTop: 1 }}>{item.value}</div>
                  </div>
                </div>
              ))}
            </>
          )}

          {tab === "courses" && (
            <>
              {[
                { name: "B.Tech Computer Science", duration: "4 years", seats: 120, fees: "₹18L/yr", cutoff: "260", color: G.green },
                { name: "B.Tech Electrical Engg", duration: "4 years", seats: 80, fees: "₹18L/yr", cutoff: "270", color: G.blue },
                { name: "B.Tech Mechanical Engg", duration: "4 years", seats: 100, fees: "₹18L/yr", cutoff: "290", color: G.orange },
                { name: "M.Tech Artificial Intel", duration: "2 years", seats: 40, fees: "₹8L/yr", cutoff: "N/A", color: G.purple },
              ].map((c, i) => (
                <div key={i} style={{ padding: "14px 16px", marginBottom: 10, background: G.surface, border: `1px solid ${c.color}22`, borderRadius: 16, cursor: "pointer" }}>
                  <div style={{ fontSize: 14, fontWeight: 800, color: G.white, marginBottom: 8 }}>{c.name}</div>
                  <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                    <Badge label={c.duration} color={c.color} />
                    <Badge label={`${c.seats} seats`} color={G.white30} />
                    <Badge label={c.fees} color={G.yellow} />
                    <Badge label={`Cutoff: ${c.cutoff}`} color={G.red} />
                  </div>
                </div>
              ))}
            </>
          )}

          {tab === "placements" && (
            <>
              <NotchedCard bg={`linear-gradient(135deg,#1C8A5E,${G.blue})`} notchColor={G.black} actionIcon="→" actionBg={G.green} actionColor={G.black} style={{ marginBottom: 14 }}>
                <div style={{ fontSize: 10, fontWeight: 800, color: "rgba(255,255,255,0.5)", letterSpacing: "0.1em", marginBottom: 6 }}>2024 PLACEMENTS</div>
                <div style={{ fontSize: 36, fontWeight: 900, color: "#fff", letterSpacing: "-1px" }}>₹18 LPA</div>
                <div style={{ fontSize: 13, color: "rgba(255,255,255,0.6)", marginTop: 4 }}>Average Package · 95% placement rate</div>
              </NotchedCard>
              {["Google", "Microsoft", "Amazon", "Goldman Sachs", "Uber", "Adobe"].map((c, i) => (
                <div key={i} style={{ display: "flex", alignItems: "center", gap: 12, padding: "12px 14px", marginBottom: 8, background: G.surface, borderRadius: 14, border: `1px solid ${G.border}` }}>
                  <div style={{ width: 36, height: 36, borderRadius: 12, background: G.surface2, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16 }}>🏢</div>
                  <span style={{ fontSize: 14, fontWeight: 700, color: G.white }}>{c}</span>
                  <span style={{ marginLeft: "auto", fontSize: 12, color: G.green, fontWeight: 800 }}>{["₹45L", "₹38L", "₹36L", "₹40L", "₹32L", "₹28L"][i]}</span>
                </div>
              ))}
            </>
          )}

          {tab === "reviews" && (
            <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, padding: "14px", textAlign: "center" }}>
              <div style={{ fontSize: 32, marginBottom: 8 }}>⭐</div>
              <div style={{ fontSize: 22, fontWeight: 900, color: G.white }}>4.6 / 5</div>
              <div style={{ fontSize: 13, color: G.white30 }}>Based on 2,340 student reviews</div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 7. SETTINGS SCREEN
// ══════════════════════════════════════════════════════════════
function SettingsScreen({ setScreen }) {
  const [notifs, setNotifs] = useState(true);
  const [darkMode, setDarkMode] = useState(true);
  const [biometric, setBiometric] = useState(true);

  const Toggle = ({ value, onChange }) => (
    <div onClick={() => onChange(!value)} style={{ width: 44, height: 26, borderRadius: 13, background: value ? G.green : G.surface2, border: `1.5px solid ${value ? G.green : G.border}`, position: "relative", cursor: "pointer", transition: "all 0.25s", boxShadow: value ? `0 0 10px ${G.green}55` : "none" }}>
      <div style={{ position: "absolute", top: 2, left: value ? 20 : 2, width: 18, height: 18, borderRadius: 9, background: value ? G.black : G.white30, transition: "left 0.25s" }} />
    </div>
  );

  return (
    <div style={{ height: "100%", background: G.black, display: "flex", flexDirection: "column" }}>
      <StatusBar />
      <BackHeader title="SETTINGS" onBack={() => setScreen("profile")} />

      <div style={{ flex: 1, overflowY: "auto", padding: "16px 18px 28px" }}>

        {/* Account */}
        <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", marginBottom: 10 }}>ACCOUNT</div>
        <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, overflow: "hidden", marginBottom: 18 }}>
          {[
            { icon: "✉️", label: "Email", value: "aaryan@example.com" },
            { icon: "📱", label: "Phone", value: "+91 98765 43210" },
            { icon: "🔑", label: "Change Password", value: "" },
          ].map((item, i) => (
            <div key={i} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", borderBottom: i < 2 ? `1px solid ${G.border}` : "none", cursor: "pointer" }}>
              <span style={{ fontSize: 18, width: 28, textAlign: "center" }}>{item.icon}</span>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 700, color: G.white }}>{item.label}</div>
                {item.value && <div style={{ fontSize: 11, color: G.white30, marginTop: 1 }}>{item.value}</div>}
              </div>
              <span style={{ fontSize: 16, color: G.white30 }}>›</span>
            </div>
          ))}
        </div>

        {/* Preferences */}
        <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", marginBottom: 10 }}>PREFERENCES</div>
        <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, overflow: "hidden", marginBottom: 18 }}>
          {[
            { icon: "🔔", label: "Push Notifications", toggle: true, value: notifs, set: setNotifs },
            { icon: "🌙", label: "Dark Mode", toggle: true, value: darkMode, set: setDarkMode },
            { icon: "👆", label: "Biometric Login", toggle: true, value: biometric, set: setBiometric },
            { icon: "🌐", label: "Language", toggle: false, value: "English" },
            { icon: "🔔", label: "Notification Prefs", toggle: false },
          ].map((item, i) => (
            <div key={i} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", borderBottom: i < 4 ? `1px solid ${G.border}` : "none", cursor: "pointer" }}>
              <span style={{ fontSize: 18, width: 28, textAlign: "center" }}>{item.icon}</span>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 700, color: G.white }}>{item.label}</div>
                {!item.toggle && item.value && <div style={{ fontSize: 11, color: G.white30, marginTop: 1 }}>{item.value}</div>}
              </div>
              {item.toggle ? <Toggle value={item.value} onChange={item.set} /> : <span style={{ fontSize: 16, color: G.white30 }}>›</span>}
            </div>
          ))}
        </div>

        {/* Privacy */}
        <div style={{ fontSize: 10, fontWeight: 800, color: G.white30, letterSpacing: "0.1em", marginBottom: 10 }}>PRIVACY & LEGAL</div>
        <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, overflow: "hidden", marginBottom: 18 }}>
          {["Privacy Policy", "Terms of Service", "Data & Storage", "Connected Apps"].map((item, i, arr) => (
            <div key={i} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", borderBottom: i < arr.length - 1 ? `1px solid ${G.border}` : "none", cursor: "pointer" }}>
              <span style={{ fontSize: 14, fontWeight: 700, color: G.white, flex: 1 }}>{item}</span>
              <span style={{ fontSize: 16, color: G.white30 }}>›</span>
            </div>
          ))}
        </div>

        {/* App info */}
        <div style={{ background: G.surface, border: `1px solid ${G.border}`, borderRadius: 16, padding: "14px 16px", marginBottom: 18, textAlign: "center" }}>
          <div style={{ fontSize: 32, marginBottom: 6 }}>🎓</div>
          <div style={{ fontSize: 13, fontWeight: 800, color: G.white }}>EDUING</div>
          <div style={{ fontSize: 11, color: G.white30 }}>Version 1.0.0 · Build 42</div>
        </div>

        {/* Danger */}
        <div style={{ background: G.surface, border: `1px solid ${G.red}22`, borderRadius: 16, overflow: "hidden" }}>
          {[{ icon: "🚪", label: "Log Out", color: G.white60 }, { icon: "🗑️", label: "Delete Account", color: G.red }].map((item, i) => (
            <div key={i} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px 16px", borderBottom: i === 0 ? `1px solid ${G.border}` : "none", cursor: "pointer" }}>
              <span style={{ fontSize: 18 }}>{item.icon}</span>
              <span style={{ fontSize: 14, fontWeight: 700, color: item.color }}>{item.label}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// ROOT
// ══════════════════════════════════════════════════════════════
export default function App() {
  const [screen, setScreen] = useState("planner");
  const [nav, setNav] = useState("plan");

  const handleNav = (id) => {
    setNav(id);
    const map = { home: "dashboard", uni: "discover", apps: "applications", ai: "copilot", plan: "planner" };
    if (map[id]) setScreen(map[id]);
  };

  const screens = {
    planner: <PlannerScreen setNav={handleNav} setScreen={setScreen} />,
    sop: <SOPScreen setScreen={setScreen} />,
    resume: <ResumeScreen setScreen={setScreen} />,
    interview: <InterviewScreen setScreen={setScreen} />,
    scholarships: <ScholarshipsScreen setNav={handleNav} />,
    unidetail: <UniDetailScreen setScreen={setScreen} />,
    settings: <SettingsScreen setScreen={setScreen} />,
  };

  const labels = { planner: "Planner", sop: "SOP Builder", resume: "Resume", interview: "Interview", scholarships: "Scholarships", unidetail: "Uni Detail", settings: "Settings" };

  return (
    <div style={{ minHeight: "100vh", background: "#050505", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", padding: 40, gap: 28, fontFamily: "'SF Pro Display',-apple-system,BlinkMacSystemFont,sans-serif" }}>
      <style>{`
        *{box-sizing:border-box;margin:0;padding:0;}
        ::-webkit-scrollbar{width:0;}
        input,textarea{font-family:inherit;}
        input::placeholder,textarea::placeholder{color:rgba(255,255,255,0.2);}
        @keyframes blink{0%,100%{opacity:1}50%{opacity:0}}
      `}</style>

      <div style={{ display: "flex", gap: 6, background: "rgba(255,255,255,0.04)", padding: 6, borderRadius: 30, border: "1px solid rgba(255,255,255,0.06)", flexWrap: "wrap", justifyContent: "center" }}>
        {Object.keys(screens).map(s => (
          <button key={s} onClick={() => setScreen(s)} style={{ padding: "7px 14px", borderRadius: 18, border: "none", background: screen === s ? G.green : "transparent", color: screen === s ? G.black : "rgba(255,255,255,0.35)", fontWeight: 800, cursor: "pointer", fontSize: 11, transition: "all 0.2s", fontFamily: "inherit", letterSpacing: "0.02em" }}>{labels[s]}</button>
        ))}
      </div>

      <div style={{ width: 360, height: 740, background: G.black, borderRadius: 48, overflow: "hidden", boxShadow: "0 60px 120px rgba(0,0,0,0.8), 0 0 0 1px rgba(255,255,255,0.06)", border: `7px solid #1A1A1A`, position: "relative", display: "flex", flexDirection: "column" }}>
        <div style={{ flex: 1, overflow: "hidden", position: "relative" }}>
          {screens[screen]}
        </div>
      </div>
    </div>
  );
}
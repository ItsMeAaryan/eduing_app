import { useState } from "react";

const G = {
  green:   "#3DFF54",
  black:   "#0A0A0A",
  black2:  "#111111",
  surface: "#1A1A1A",
  surface2:"#222222",
  border:  "#2A2A2A",
  white:   "#FFFFFF",
  white60: "rgba(255,255,255,0.6)",
  white30: "rgba(255,255,255,0.3)",
  white10: "rgba(255,255,255,0.08)",
  purple:  "#7B5EA7",
  blue:    "#3B5BFF",
  orange:  "#FF6B35",
  yellow:  "#F5A623",
  red:     "#FF3B30",
  pink:    "#FF3B7A",
};

// ── SHARED COMPONENTS ──────────────────────────────────────────

function Badge({ label, color=G.green }) {
  return (
    <div style={{ display:"inline-flex", alignItems:"center", height:20, padding:"0 8px", borderRadius:10, background:color+"22", border:`1px solid ${color}44` }}>
      <span style={{ fontSize:9, fontWeight:900, color, letterSpacing:"0.08em" }}>{label}</span>
    </div>
  );
}

function ProgressBar({ value, color=G.green, height=4 }) {
  return (
    <div style={{ height, borderRadius:height/2, background:G.border, overflow:"hidden" }}>
      <div style={{ height:"100%", width:`${value}%`, borderRadius:height/2, background:color, boxShadow:`0 0 8px ${color}66` }}/>
    </div>
  );
}

function NotchedCard({ children, bg=G.surface, notchColor=G.black, actionIcon, actionBg=G.green, actionColor=G.black, style={} }) {
  const [p, setP] = useState(false);
  return (
    <div style={{ position:"relative", ...style }}>
      <div style={{ background:bg, borderRadius:20, padding:"18px", position:"relative", overflow:"hidden", boxShadow:"0 8px 24px rgba(0,0,0,0.4)" }}>
        {children}
        <div style={{ position:"absolute", bottom:-20, right:-20, width:52, height:52, borderRadius:"50%", background:notchColor }}/>
      </div>
      {actionIcon && (
        <div onMouseDown={()=>setP(true)} onMouseUp={()=>setP(false)}
          style={{ position:"absolute", bottom:-10, right:-10, width:44, height:44, borderRadius:22, background:actionBg, display:"flex", alignItems:"center", justifyContent:"center", fontSize:18, cursor:"pointer", zIndex:10, boxShadow:`0 6px 20px ${actionBg}66`, transform:p?"scale(0.9)":"scale(1)", transition:"transform 0.1s", color:actionColor, fontWeight:900 }}>
          {actionIcon}
        </div>
      )}
    </div>
  );
}

function FloatingNav({ active, onChange }) {
  const tabs = [
    { id:"home", icon:"⊞", label:"Home" },
    { id:"uni",  icon:"🏛", label:"Discover" },
    { id:"apps", icon:"📋", label:"Apply" },
    { id:"ai",   icon:"✦",  label:"Copilot" },
    { id:"plan", icon:"📅", label:"Planner" },
  ];
  return (
    <div style={{ position:"absolute", bottom:16, left:16, right:16, height:62, background:"rgba(26,26,26,0.95)", backdropFilter:"blur(20px)", borderRadius:31, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"space-around", padding:"0 6px", zIndex:50, boxShadow:"0 8px 32px rgba(0,0,0,0.6)" }}>
      {tabs.map(t => {
        const on = t.id===active;
        return (
          <div key={t.id} onClick={()=>onChange(t.id)} style={{ display:"flex", flexDirection:"column", alignItems:"center", gap:2, cursor:"pointer", padding:"6px 10px", borderRadius:18, background:on?"rgba(61,255,84,0.12)":"transparent", transition:"all 0.2s", minWidth:44 }}>
            <span style={{ fontSize:on?18:15, filter:on?"none":"grayscale(1) opacity(0.4)", transition:"all 0.2s" }}>{t.icon}</span>
            {on && <span style={{ fontSize:8, fontWeight:900, color:G.green, letterSpacing:"0.04em" }}>{t.label}</span>}
          </div>
        );
      })}
    </div>
  );
}

function StatusBar() {
  return (
    <div style={{ height:40, display:"flex", alignItems:"center", justifyContent:"space-between", padding:"0 22px", flexShrink:0 }}>
      <span style={{ fontSize:13, fontWeight:700, color:G.white }}>9:41</span>
      <div style={{ display:"flex", gap:4, alignItems:"center" }}>
        {[0.4,0.7,1].map((o,i)=><div key={i} style={{ width:3+i*0.5, height:6+i*2, background:G.white, borderRadius:1, opacity:o }}/>)}
        <div style={{ width:14, height:7, border:`1.5px solid ${G.white}`, borderRadius:3, marginLeft:3, position:"relative", opacity:0.8 }}>
          <div style={{ position:"absolute", left:1, top:1, right:2, bottom:1, background:G.white, borderRadius:1 }}/>
        </div>
      </div>
    </div>
  );
}

function BackHeader({ title, onBack }) {
  return (
    <div style={{ display:"flex", alignItems:"center", gap:12, padding:"6px 18px 0" }}>
      <div onClick={onBack} style={{ width:32, height:32, borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer" }}>
        <span style={{ color:G.white, fontSize:14 }}>←</span>
      </div>
      <span style={{ fontSize:12, fontWeight:800, color:G.white30, letterSpacing:"0.08em" }}>{title}</span>
    </div>
  );
}

function Screen({ children, nav, setNav, showNav=true }) {
  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column", position:"relative" }}>
      <StatusBar/>
      <div style={{ flex:1, overflowY:"auto", paddingBottom: showNav?90:20 }}>
        {children}
      </div>
      {showNav && <FloatingNav active={nav} onChange={setNav}/>}
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 1. DISCOVER SCREEN
// ══════════════════════════════════════════════════════════════
function DiscoverScreen({ setNav }) {
  const [q, setQ] = useState("");
  const [filter, setFilter] = useState("All");
  const [saved, setSaved] = useState([]);
  const filters = ["All","Engineering","Management","Medicine","Law","Arts"];
  const unis = [
    { name:"BITS Pilani",        loc:"Pilani, Rajasthan",   rank:"NIRF #1",  match:96, color:G.green,  fees:"₹18L/yr", seats:120 },
    { name:"IIT Bombay",         loc:"Mumbai, Maharashtra", rank:"NIRF #2",  match:88, color:G.blue,   fees:"₹2.2L/yr",seats:80  },
    { name:"Delhi University",   loc:"New Delhi, Delhi",    rank:"NIRF #3",  match:81, color:G.purple, fees:"₹15K/yr", seats:200 },
    { name:"VIT Vellore",        loc:"Vellore, Tamil Nadu", rank:"NIRF #11", match:74, color:G.orange, fees:"₹3.5L/yr",seats:300 },
  ];

  return (
    <Screen nav="uni" setNav={setNav} showNav={true}>
      <div style={{ padding:"0 18px" }}>
        {/* Header */}
        <div style={{ display:"flex", alignItems:"flex-start", justifyContent:"space-between", marginBottom:16, paddingTop:4 }}>
          <div>
            <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.12em", marginBottom:3 }}>EXPLORE</div>
            <div style={{ fontSize:26, fontWeight:900, color:G.white, letterSpacing:"-0.5px" }}>Discover</div>
          </div>
          <div style={{ width:36, height:36, borderRadius:18, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:16 }}>🔖</div>
        </div>

        {/* Search bar */}
        <div style={{ display:"flex", gap:10, marginBottom:16 }}>
          <div style={{ flex:1, height:46, background:G.surface, border:`1.5px solid ${G.border}`, borderRadius:23, display:"flex", alignItems:"center", padding:"0 14px", gap:10 }}>
            <span style={{ fontSize:15, color:G.white30 }}>🔍</span>
            <input value={q} onChange={e=>setQ(e.target.value)} placeholder="Search universities, programs..."
              style={{ flex:1, border:"none", background:"transparent", fontSize:13, color:G.white, outline:"none", fontFamily:"inherit" }}/>
          </div>
          <div style={{ width:46, height:46, borderRadius:23, background:G.green, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:16 }}>⊟</div>
        </div>

        {/* Filter chips */}
        <div style={{ display:"flex", gap:8, marginBottom:18, overflowX:"auto", paddingBottom:4 }}>
          {filters.map(f=>(
            <div key={f} onClick={()=>setFilter(f)} style={{
              height:32, padding:"0 14px", borderRadius:16, cursor:"pointer",
              background: filter===f ? G.green : G.surface,
              border:`1.5px solid ${filter===f?G.green:G.border}`,
              display:"flex", alignItems:"center", whiteSpace:"nowrap",
              transition:"all 0.2s",
            }}>
              <span style={{ fontSize:12, fontWeight:800, color:filter===f?G.black:G.white60 }}>{f}</span>
            </div>
          ))}
        </div>

        {/* Count + sort */}
        <div style={{ display:"flex", alignItems:"center", justifyContent:"space-between", marginBottom:14 }}>
          <span style={{ fontSize:13, fontWeight:800, color:G.white }}>{unis.length} Universities</span>
          <div style={{ display:"flex", alignItems:"center", gap:6, cursor:"pointer" }}>
            <span style={{ fontSize:12, fontWeight:700, color:G.green }}>Sort: Match</span>
            <span style={{ fontSize:10, color:G.green }}>↓</span>
          </div>
        </div>

        {/* University cards */}
        {unis.map((u,i)=>(
          <NotchedCard key={i} bg={G.surface} notchColor={G.black} actionIcon="→" actionBg={u.color} actionColor={u.color===G.green?G.black:G.white} style={{ marginBottom:14 }}>
            <div style={{ display:"flex", gap:12, alignItems:"flex-start" }}>
              {/* Logo placeholder */}
              <div style={{ width:48, height:48, borderRadius:16, background:u.color+"18", border:`1.5px solid ${u.color}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:22, flexShrink:0 }}>🏛</div>
              <div style={{ flex:1, minWidth:0 }}>
                <div style={{ display:"flex", alignItems:"center", gap:8, marginBottom:2, flexWrap:"wrap" }}>
                  <span style={{ fontSize:15, fontWeight:900, color:G.white }}>{u.name}</span>
                  <Badge label={u.rank} color={u.color}/>
                </div>
                <div style={{ fontSize:12, color:G.white30, marginBottom:10 }}>📍 {u.loc}</div>
                {/* Match */}
                <div style={{ display:"flex", alignItems:"center", gap:8, marginBottom:8 }}>
                  <ProgressBar value={u.match} color={u.color} height={4}/>
                  <span style={{ fontSize:11, fontWeight:900, color:u.color, whiteSpace:"nowrap" }}>{u.match}%</span>
                </div>
                {/* Meta */}
                <div style={{ display:"flex", gap:10 }}>
                  <div style={{ display:"flex", alignItems:"center", gap:4 }}>
                    <span style={{ fontSize:10, color:G.white30 }}>💰</span>
                    <span style={{ fontSize:10, fontWeight:700, color:G.white60 }}>{u.fees}</span>
                  </div>
                  <div style={{ display:"flex", alignItems:"center", gap:4 }}>
                    <span style={{ fontSize:10, color:G.white30 }}>💺</span>
                    <span style={{ fontSize:10, fontWeight:700, color:G.white60 }}>{u.seats} seats</span>
                  </div>
                  <div onClick={()=>setSaved(p=>p.includes(i)?p.filter(x=>x!==i):[...p,i])} style={{ marginLeft:"auto", cursor:"pointer" }}>
                    <span style={{ fontSize:16, filter:saved.includes(i)?"none":"grayscale(1) opacity(0.4)" }}>🔖</span>
                  </div>
                </div>
              </div>
            </div>
          </NotchedCard>
        ))}
      </div>
    </Screen>
  );
}

// ══════════════════════════════════════════════════════════════
// 2. APPLICATIONS SCREEN
// ══════════════════════════════════════════════════════════════
function ApplicationsScreen({ setNav }) {
  const [tab, setTab] = useState("active");
  const apps = {
    active: [
      { name:"BITS Pilani",      course:"B.Tech CSE",    progress:91, deadline:"Aug 30", color:G.green,  status:"IN PROGRESS" },
      { name:"IIT Bombay",       course:"B.Tech EE",     progress:67, deadline:"Sep 15", color:G.blue,   status:"IN PROGRESS" },
      { name:"Delhi University", course:"B.Sc Honours",  progress:45, deadline:"Oct 1",  color:G.purple, status:"DRAFT"       },
    ],
    offers: [
      { name:"VIT Vellore",     course:"B.Tech CSE",  progress:100, deadline:"Accept by Aug 10", color:G.orange, status:"OFFER" },
      { name:"Manipal Uni",     course:"B.Tech IT",   progress:100, deadline:"Accept by Aug 20", color:G.pink,   status:"OFFER" },
    ],
    withdrawn: [
      { name:"Amity University", course:"BCA", progress:100, deadline:"Withdrawn Jul 1", color:G.white30, status:"WITHDRAWN" },
    ],
  };

  const current = apps[tab] || [];

  return (
    <Screen nav="apps" setNav={setNav}>
      <div style={{ padding:"0 18px" }}>
        <div style={{ paddingTop:4, marginBottom:18 }}>
          <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.12em", marginBottom:3 }}>MY</div>
          <div style={{ display:"flex", alignItems:"center", justifyContent:"space-between" }}>
            <div style={{ fontSize:26, fontWeight:900, color:G.white, letterSpacing:"-0.5px" }}>Applications</div>
            <div style={{ width:36, height:36, borderRadius:18, background:G.green, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:18 }}>+</div>
          </div>
        </div>

        {/* Stats row */}
        <div style={{ display:"flex", gap:10, marginBottom:18 }}>
          {[
            { label:"Total",    value: Object.values(apps).flat().length, color:G.white },
            { label:"Active",   value: apps.active.length,    color:G.green  },
            { label:"Offers",   value: apps.offers.length,    color:G.orange },
          ].map(s=>(
            <div key={s.label} style={{ flex:1, background:G.surface, border:`1px solid ${G.border}`, borderRadius:16, padding:"12px" }}>
              <div style={{ fontSize:9, fontWeight:800, color:G.white30, letterSpacing:"0.08em", marginBottom:4 }}>{s.label.toUpperCase()}</div>
              <div style={{ fontSize:22, fontWeight:900, color:s.color }}>{s.value}</div>
            </div>
          ))}
        </div>

        {/* Tab switcher */}
        <div style={{ display:"flex", gap:6, marginBottom:18, background:G.surface, borderRadius:20, padding:4 }}>
          {[["active","Active"],["offers","Offers"],["withdrawn","Past"]].map(([id,label])=>(
            <div key={id} onClick={()=>setTab(id)} style={{
              flex:1, height:34, borderRadius:17, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer",
              background: tab===id ? (id==="offers"?G.orange:id==="withdrawn"?G.surface2:G.green) : "transparent",
              transition:"all 0.2s",
            }}>
              <span style={{ fontSize:12, fontWeight:800, color: tab===id?(id==="offers"||id==="withdrawn"?G.white:G.black):G.white30 }}>{label}</span>
            </div>
          ))}
        </div>

        {/* Application cards */}
        {current.length===0 ? (
          <div style={{ textAlign:"center", padding:"40px 0" }}>
            <div style={{ fontSize:48, marginBottom:12 }}>📋</div>
            <div style={{ fontSize:15, fontWeight:800, color:G.white60 }}>No applications here</div>
          </div>
        ) : current.map((a,i)=>(
          <NotchedCard key={i} bg={G.surface} notchColor={G.black} actionIcon={a.status==="OFFER"?"✓":"→"} actionBg={a.color} actionColor={a.color===G.green||a.color===G.orange?G.black:G.white} style={{ marginBottom:14 }}>
            <div style={{ display:"flex", alignItems:"flex-start", gap:12, marginBottom:14 }}>
              <div style={{ width:44, height:44, borderRadius:14, background:a.color+"18", border:`1.5px solid ${a.color}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:20, flexShrink:0 }}>🏛</div>
              <div style={{ flex:1 }}>
                <div style={{ fontSize:15, fontWeight:900, color:G.white, marginBottom:2 }}>{a.name}</div>
                <div style={{ fontSize:12, color:G.white60 }}>{a.course}</div>
              </div>
              <Badge label={a.status} color={a.color}/>
            </div>
            <ProgressBar value={a.progress} color={a.color} height={4}/>
            <div style={{ display:"flex", justifyContent:"space-between", marginTop:8 }}>
              <span style={{ fontSize:11, color:G.white30 }}>📅 {a.deadline}</span>
              <span style={{ fontSize:12, fontWeight:900, color:a.color }}>{a.progress}%</span>
            </div>
          </NotchedCard>
        ))}
      </div>
    </Screen>
  );
}

// ══════════════════════════════════════════════════════════════
// 3. AI COPILOT SCREEN
// ══════════════════════════════════════════════════════════════
function CopilotScreen({ setNav, setScreen }) {
  const features = [
    { icon:"📝", label:"SOP Builder",    sub:"Draft & refine",  color:G.purple, route:"sop"      },
    { icon:"👤", label:"Resume AI",      sub:"ATS optimized",   color:G.blue,   route:"resume"   },
    { icon:"🎤", label:"Mock Interview", sub:"AI feedback",     color:"#1C8A5E",route:"interview" },
    { icon:"📄", label:"Vault Analysis", sub:"Doc insights",    color:G.yellow, route:"vault"    },
    { icon:"🎓", label:"Uni Recommender",sub:"AI matched",      color:G.orange, route:"recommend"},
    { icon:"✍️", label:"Essay Writer",   sub:"Personal stmt",   color:G.pink,   route:"essay"    },
  ];

  return (
    <Screen nav="ai" setNav={setNav}>
      <div style={{ padding:"0 18px" }}>
        {/* Header */}
        <div style={{ paddingTop:4, marginBottom:18 }}>
          <div style={{ fontSize:10, fontWeight:800, color:G.green, letterSpacing:"0.12em", marginBottom:3 }}>AI STRATEGIST</div>
          <div style={{ fontSize:26, fontWeight:900, color:G.white, letterSpacing:"-0.5px" }}>Copilot</div>
        </div>

        {/* Hero readiness card */}
        <NotchedCard
          bg={`linear-gradient(135deg, ${G.purple} 0%, ${G.blue} 100%)`}
          notchColor={G.black}
          actionIcon="✦"
          actionBg={G.green}
          actionColor={G.black}
          style={{ marginBottom:14 }}
        >
          <div style={{ fontSize:10, fontWeight:800, color:"rgba(255,255,255,0.6)", letterSpacing:"0.1em", marginBottom:6 }}>OVERALL READINESS</div>
          <div style={{ fontSize:48, fontWeight:900, color:"#fff", letterSpacing:"-2px", lineHeight:1, marginBottom:6 }}>82%</div>
          <div style={{ fontSize:13, color:"rgba(255,255,255,0.6)", marginBottom:14 }}>SOP, resume & interview ready</div>
          <ProgressBar value={82} color="rgba(255,255,255,0.9)" height={4}/>
          <div style={{ display:"flex", justifyContent:"space-between", marginTop:8 }}>
            <span style={{ fontSize:11, color:"rgba(255,255,255,0.4)" }}>Powered by Gemini AI</span>
            <span style={{ fontSize:11, fontWeight:800, color:"rgba(255,255,255,0.8)" }}>3 tasks left</span>
          </div>
        </NotchedCard>

        {/* AI Chat shortcut */}
        <div onClick={()=>setScreen("chat")} style={{
          display:"flex", alignItems:"center", gap:12,
          padding:"14px 16px", marginBottom:18,
          background:G.green+"18", border:`1.5px solid ${G.green}44`,
          borderRadius:16, cursor:"pointer",
        }}>
          <div style={{ width:38, height:38, borderRadius:12, background:G.green, display:"flex", alignItems:"center", justifyContent:"center", fontSize:18 }}>✦</div>
          <div style={{ flex:1 }}>
            <div style={{ fontSize:14, fontWeight:800, color:G.white }}>Ask Copilot anything</div>
            <div style={{ fontSize:12, color:G.white30 }}>Chat with your AI admission expert</div>
          </div>
          <span style={{ fontSize:18, color:G.green }}>→</span>
        </div>

        {/* Feature grid */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:12 }}>AI TOOLS</div>
        <div style={{ display:"grid", gridTemplateColumns:"1fr 1fr", gap:10, marginBottom:18 }}>
          {features.map(f=>(
            <div key={f.label} onClick={()=>setScreen(f.route)} style={{
              background:G.surface, borderRadius:16, padding:"16px",
              border:`1px solid ${f.color}22`, cursor:"pointer",
              transition:"all 0.15s",
            }}>
              <div style={{ width:40, height:40, borderRadius:14, background:f.color+"22", display:"flex", alignItems:"center", justifyContent:"center", fontSize:20, marginBottom:10 }}>{f.icon}</div>
              <div style={{ fontSize:13, fontWeight:800, color:G.white, marginBottom:3 }}>{f.label}</div>
              <div style={{ fontSize:11, color:G.white30 }}>{f.sub}</div>
              <div style={{ marginTop:10 }}>
                <div style={{ height:28, padding:"0 10px", borderRadius:14, background:f.color+"22", border:`1px solid ${f.color}44`, display:"inline-flex", alignItems:"center" }}>
                  <span style={{ fontSize:10, fontWeight:800, color:f.color }}>Open →</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Insights */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:12 }}>PERSONALIZED INSIGHTS</div>
        <div style={{ background:G.surface, border:`1px solid ${G.border}`, borderRadius:16, padding:"16px" }}>
          {[
            { icon:"⚡", text:"SOP alignment for target programs is 88%", color:G.yellow },
            { icon:"✅", text:"Strong match: STEM Innovators Grant (94%)", color:G.green  },
            { icon:"⚠️", text:"Interview prep incomplete — 3 sessions left",color:G.red   },
          ].map((ins,i)=>(
            <div key={i} style={{ display:"flex", gap:10, alignItems:"flex-start", marginBottom:i<2?14:0 }}>
              <div style={{ width:30, height:30, borderRadius:10, background:ins.color+"18", display:"flex", alignItems:"center", justifyContent:"center", fontSize:13, flexShrink:0 }}>{ins.icon}</div>
              <div style={{ fontSize:13, color:G.white60, lineHeight:1.45, paddingTop:5 }}>{ins.text}</div>
            </div>
          ))}
        </div>
      </div>
    </Screen>
  );
}

// ══════════════════════════════════════════════════════════════
// 4. COPILOT CHAT SCREEN (fixes /copilot/chat 404)
// ══════════════════════════════════════════════════════════════
function CopilotChatScreen({ setScreen }) {
  const [msg, setMsg] = useState("");
  const [messages, setMessages] = useState([
    { from:"ai",   text:"Hey Aaryan 👋 I'm your AI admission strategist. What do you need help with today?" },
    { from:"user", text:"What are my chances at BITS Pilani CSE?" },
    { from:"ai",   text:"Based on your profile — JEE score, 12th marks, and extracurriculars — I estimate a 78% admission probability for BITS Pilani CSE. Your rank needs to be under 2,500 for Pilani campus. Want me to break down what you can improve?" },
  ]);

  const send = () => {
    if(!msg.trim()) return;
    setMessages(p=>[...p, { from:"user", text:msg }, { from:"ai", text:"Analysing your question..." }]);
    setMsg("");
  };

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <BackHeader title="AI COPILOT CHAT" onBack={()=>setScreen("copilot")}/>

      {/* Messages */}
      <div style={{ flex:1, overflowY:"auto", padding:"16px 18px", display:"flex", flexDirection:"column", gap:12 }}>
        {messages.map((m,i)=>(
          <div key={i} style={{ display:"flex", justifyContent:m.from==="user"?"flex-end":"flex-start" }}>
            {m.from==="ai" && (
              <div style={{ width:28, height:28, borderRadius:14, background:G.green, display:"flex", alignItems:"center", justifyContent:"center", fontSize:13, marginRight:8, flexShrink:0, alignSelf:"flex-end" }}>✦</div>
            )}
            <div style={{
              maxWidth:"78%", padding:"12px 14px", borderRadius:18,
              background: m.from==="user" ? G.green : G.surface,
              color: m.from==="user" ? G.black : G.white,
              fontSize:13, lineHeight:1.5, fontWeight: m.from==="user"?700:400,
              borderBottomRightRadius: m.from==="user"?4:18,
              borderBottomLeftRadius: m.from==="ai"?4:18,
            }}>{m.text}</div>
          </div>
        ))}
      </div>

      {/* Suggestions */}
      <div style={{ padding:"0 18px 10px", display:"flex", gap:8, overflowX:"auto" }}>
        {["My chances?","Improve SOP","Best scholarships","Interview tips"].map(s=>(
          <div key={s} onClick={()=>setMsg(s)} style={{ height:32, padding:"0 12px", borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", whiteSpace:"nowrap", cursor:"pointer" }}>
            <span style={{ fontSize:11, fontWeight:700, color:G.white60 }}>{s}</span>
          </div>
        ))}
      </div>

      {/* Input */}
      <div style={{ padding:"10px 18px 28px", display:"flex", gap:10 }}>
        <div style={{ flex:1, height:48, background:G.surface, border:`1.5px solid ${G.border}`, borderRadius:24, display:"flex", alignItems:"center", padding:"0 16px" }}>
          <input value={msg} onChange={e=>setMsg(e.target.value)} onKeyDown={e=>e.key==="Enter"&&send()}
            placeholder="Ask anything about admissions..."
            style={{ flex:1, border:"none", background:"transparent", fontSize:14, color:G.white, outline:"none", fontFamily:"inherit" }}/>
        </div>
        <div onClick={send} style={{ width:48, height:48, borderRadius:24, background:G.green, display:"flex", alignItems:"center", justifyContent:"center", fontSize:18, cursor:"pointer", flexShrink:0 }}>→</div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 5. SECURE VAULT SCREEN
// ══════════════════════════════════════════════════════════════
function VaultScreen({ setNav }) {
  const [activeTab, setActiveTab] = useState("All");
  const tabs = ["All","Academic","Identity","Financial"];
  const docs = [
    { name:"10th Marksheet",    cat:"Academic",  status:"VERIFIED",  icon:"📄", color:G.green  },
    { name:"12th Marksheet",    cat:"Academic",  status:"VERIFIED",  icon:"📄", color:G.green  },
    { name:"Aadhaar Card",      cat:"Identity",  status:"PENDING",   icon:"🪪", color:G.yellow },
    { name:"Passport",          cat:"Identity",  status:"MISSING",   icon:"📘", color:G.red    },
    { name:"JEE Scorecard",     cat:"Academic",  status:"VERIFIED",  icon:"📊", color:G.green  },
    { name:"Income Certificate",cat:"Financial", status:"PENDING",   icon:"💰", color:G.yellow },
  ];
  const filtered = activeTab==="All" ? docs : docs.filter(d=>d.cat===activeTab);
  const verified = docs.filter(d=>d.status==="VERIFIED").length;
  const pending  = docs.filter(d=>d.status==="PENDING").length;

  return (
    <Screen nav="home" setNav={setNav}>
      <div style={{ padding:"0 18px" }}>
        <div style={{ paddingTop:4, marginBottom:18 }}>
          <div style={{ fontSize:10, fontWeight:800, color:G.green, letterSpacing:"0.12em", marginBottom:3 }}>DOCUMENTS</div>
          <div style={{ display:"flex", alignItems:"center", justifyContent:"space-between" }}>
            <div style={{ fontSize:26, fontWeight:900, color:G.white, letterSpacing:"-0.5px" }}>Secure Vault</div>
            <div style={{ width:36, height:36, borderRadius:18, background:G.green, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:18 }}>+</div>
          </div>
        </div>

        {/* Stats */}
        <div style={{ display:"flex", gap:10, marginBottom:18 }}>
          {[
            { label:"Total",    value:docs.length, color:G.white  },
            { label:"Verified", value:verified,    color:G.green  },
            { label:"Pending",  value:pending,     color:G.yellow },
            { label:"Missing",  value:docs.length-verified-pending, color:G.red },
          ].map(s=>(
            <div key={s.label} style={{ flex:1, background:G.surface, border:`1px solid ${s.color}22`, borderRadius:14, padding:"10px 8px" }}>
              <div style={{ fontSize:8, fontWeight:800, color:G.white30, letterSpacing:"0.06em", marginBottom:4 }}>{s.label.toUpperCase()}</div>
              <div style={{ fontSize:20, fontWeight:900, color:s.color }}>{s.value}</div>
            </div>
          ))}
        </div>

        {/* Search */}
        <div style={{ height:44, background:G.surface, border:`1.5px solid ${G.border}`, borderRadius:22, display:"flex", alignItems:"center", padding:"0 14px", gap:10, marginBottom:16 }}>
          <span style={{ fontSize:14, color:G.white30 }}>🔍</span>
          <input placeholder="Search documents..." style={{ flex:1, border:"none", background:"transparent", fontSize:13, color:G.white, outline:"none", fontFamily:"inherit" }}/>
        </div>

        {/* Category tabs */}
        <div style={{ display:"flex", gap:8, marginBottom:18, overflowX:"auto", paddingBottom:4 }}>
          {tabs.map(t=>(
            <div key={t} onClick={()=>setActiveTab(t)} style={{ height:32, padding:"0 14px", borderRadius:16, cursor:"pointer", background:activeTab===t?G.green:G.surface, border:`1.5px solid ${activeTab===t?G.green:G.border}`, display:"flex", alignItems:"center", whiteSpace:"nowrap" }}>
              <span style={{ fontSize:12, fontWeight:800, color:activeTab===t?G.black:G.white60 }}>{t}</span>
            </div>
          ))}
        </div>

        {/* Document list */}
        {filtered.map((d,i)=>(
          <div key={i} style={{ display:"flex", alignItems:"center", gap:12, padding:"14px 16px", marginBottom:10, background:G.surface, borderRadius:16, border:`1px solid ${d.color}22`, cursor:"pointer" }}>
            <div style={{ width:44, height:44, borderRadius:14, background:d.color+"18", border:`1.5px solid ${d.color}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:20, flexShrink:0 }}>{d.icon}</div>
            <div style={{ flex:1 }}>
              <div style={{ fontSize:14, fontWeight:800, color:G.white }}>{d.name}</div>
              <div style={{ fontSize:11, color:G.white30, marginTop:2 }}>{d.cat}</div>
            </div>
            <Badge label={d.status} color={d.color}/>
          </div>
        ))}

        {/* Upload area */}
        <div style={{ marginTop:8, padding:"20px", background:G.surface, border:`2px dashed ${G.border}`, borderRadius:16, display:"flex", flexDirection:"column", alignItems:"center", gap:8, cursor:"pointer" }}>
          <div style={{ width:44, height:44, borderRadius:22, background:G.green+"18", border:`1.5px solid ${G.green}44`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:22 }}>📤</div>
          <div style={{ fontSize:13, fontWeight:800, color:G.white60 }}>Upload Document</div>
          <div style={{ fontSize:11, color:G.white30 }}>Camera, Gallery, or Files</div>
        </div>
      </div>
    </Screen>
  );
}

// ══════════════════════════════════════════════════════════════
// 6. PROFILE / ACCOUNT SCREEN (was missing entirely)
// ══════════════════════════════════════════════════════════════
function ProfileScreen({ setScreen }) {
  const sections = [
    { title:"PERSONAL",  items:[
      { icon:"👤", label:"Personal Information", sub:"Name, DOB, gender",       color:G.blue   },
      { icon:"📚", label:"Academic Details",     sub:"Boards, scores, grades",  color:G.purple },
      { icon:"👨‍👩‍👦", label:"Parent / Guardian",  sub:"Contact & income info",   color:G.orange },
      { icon:"📍", label:"Address",              sub:"Permanent & current",     color:G.yellow },
    ]},
    { title:"ADMISSION",  items:[
      { icon:"🏆", label:"Entrance Exams",       sub:"JEE, NEET, CAT scores",   color:G.green  },
      { icon:"📋", label:"Category & Quota",     sub:"General / OBC / SC / ST", color:G.pink   },
      { icon:"🪪", label:"Student ID",           sub:"Digital ID card & QR",    color:G.blue   },
    ]},
    { title:"ACCOUNT", items:[
      { icon:"🔒", label:"Security",             sub:"Password, 2FA, sessions",  color:G.red    },
      { icon:"🔔", label:"Notifications",        sub:"Email, SMS, push",         color:G.yellow },
      { icon:"🎨", label:"Appearance",           sub:"Theme, language",          color:G.purple },
      { icon:"🔗", label:"Connected Accounts",   sub:"Google, Apple",            color:G.blue   },
    ]},
  ];

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <div style={{ flex:1, overflowY:"auto", padding:"0 18px 28px" }}>

        {/* Profile hero */}
        <div style={{ display:"flex", flexDirection:"column", alignItems:"center", padding:"20px 0 24px", position:"relative" }}>
          {/* Avatar */}
          <div style={{ position:"relative", marginBottom:14 }}>
            <div style={{ width:88, height:88, borderRadius:44, background:`linear-gradient(135deg,${G.purple},${G.blue})`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:36, border:`3px solid ${G.green}` }}>👤</div>
            <div style={{ position:"absolute", bottom:0, right:0, width:26, height:26, borderRadius:13, background:G.green, border:`2px solid ${G.black}`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:12, cursor:"pointer" }}>✏️</div>
          </div>
          <div style={{ fontSize:22, fontWeight:900, color:G.white, letterSpacing:"-0.5px", marginBottom:4 }}>Aaryan Sharma</div>
          <div style={{ fontSize:13, color:G.white30, marginBottom:10 }}>aaryan@example.com · +91 98765 43210</div>

          {/* Profile completion */}
          <div style={{ width:"100%", background:G.surface, border:`1px solid ${G.border}`, borderRadius:16, padding:"12px 16px" }}>
            <div style={{ display:"flex", justifyContent:"space-between", alignItems:"center", marginBottom:8 }}>
              <span style={{ fontSize:12, fontWeight:800, color:G.white60 }}>Profile Completion</span>
              <span style={{ fontSize:14, fontWeight:900, color:G.green }}>72%</span>
            </div>
            <ProgressBar value={72} color={G.green} height={5}/>
            <div style={{ fontSize:11, color:G.white30, marginTop:6 }}>Add entrance exam scores to reach 85%</div>
          </div>
        </div>

        {/* Digital ID Card */}
        <NotchedCard bg={`linear-gradient(135deg, ${G.purple}, ${G.blue})`} notchColor={G.black} actionIcon="QR" actionBg={G.green} actionColor={G.black} style={{ marginBottom:20 }}>
          <div style={{ fontSize:10, fontWeight:800, color:"rgba(255,255,255,0.5)", letterSpacing:"0.1em", marginBottom:8 }}>DIGITAL STUDENT ID</div>
          <div style={{ fontSize:18, fontWeight:900, color:"#fff", marginBottom:2 }}>Aaryan Sharma</div>
          <div style={{ fontSize:12, color:"rgba(255,255,255,0.6)", marginBottom:8 }}>ID: EDU-2025-78432</div>
          <div style={{ display:"flex", gap:10 }}>
            <Badge label="B.Tech CSE" color="#fff" bg="rgba(255,255,255,0.15)"/>
            <Badge label="2025 BATCH" color="#fff" bg="rgba(255,255,255,0.15)"/>
          </div>
        </NotchedCard>

        {/* Sections */}
        {sections.map((sec,si)=>(
          <div key={si} style={{ marginBottom:20 }}>
            <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:10 }}>{sec.title}</div>
            <div style={{ background:G.surface, border:`1px solid ${G.border}`, borderRadius:16, overflow:"hidden" }}>
              {sec.items.map((item,ii)=>(
                <div key={ii} style={{
                  display:"flex", alignItems:"center", gap:12, padding:"14px 16px",
                  borderBottom: ii<sec.items.length-1 ? `1px solid ${G.border}` : "none",
                  cursor:"pointer",
                }}>
                  <div style={{ width:38, height:38, borderRadius:12, background:item.color+"18", border:`1px solid ${item.color}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:17, flexShrink:0 }}>{item.icon}</div>
                  <div style={{ flex:1 }}>
                    <div style={{ fontSize:14, fontWeight:700, color:G.white }}>{item.label}</div>
                    <div style={{ fontSize:11, color:G.white30, marginTop:1 }}>{item.sub}</div>
                  </div>
                  <span style={{ fontSize:16, color:G.white30 }}>›</span>
                </div>
              ))}
            </div>
          </div>
        ))}

        {/* Danger zone */}
        <div style={{ background:G.surface, border:`1px solid ${G.red}22`, borderRadius:16, overflow:"hidden" }}>
          {[
            { icon:"🚪", label:"Log out",        color:G.white60 },
            { icon:"🗑️", label:"Delete Account", color:G.red     },
          ].map((item,i)=>(
            <div key={i} style={{ display:"flex", alignItems:"center", gap:12, padding:"14px 16px", borderBottom:i===0?`1px solid ${G.border}`:"none", cursor:"pointer" }}>
              <span style={{ fontSize:18 }}>{item.icon}</span>
              <span style={{ fontSize:14, fontWeight:700, color:item.color }}>{item.label}</span>
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
  const [screen, setScreen] = useState("discover");
  const [nav, setNav] = useState("uni");

  const handleNav = (id) => {
    setNav(id);
    const map = { home:"dashboard", uni:"discover", apps:"applications", ai:"copilot", plan:"planner" };
    if(map[id]) setScreen(map[id]);
  };

  const screens = {
    discover:     <DiscoverScreen setNav={handleNav}/>,
    applications: <ApplicationsScreen setNav={handleNav}/>,
    copilot:      <CopilotScreen setNav={handleNav} setScreen={setScreen}/>,
    chat:         <CopilotChatScreen setScreen={setScreen}/>,
    vault:        <VaultScreen setNav={handleNav}/>,
    profile:      <ProfileScreen setScreen={setScreen}/>,
  };

  const labels = { discover:"Discover", applications:"Applications", copilot:"Copilot", chat:"AI Chat", vault:"Vault", profile:"Profile" };

  return (
    <div style={{ minHeight:"100vh", background:"#050505", display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center", padding:40, gap:28, fontFamily:"'SF Pro Display',-apple-system,BlinkMacSystemFont,sans-serif" }}>
      <style>{`*{box-sizing:border-box;margin:0;padding:0;}::-webkit-scrollbar{width:0;}input{font-family:inherit;}input::placeholder{color:rgba(255,255,255,0.2);}`}</style>

      {/* Screen switcher */}
      <div style={{ display:"flex", gap:6, background:"rgba(255,255,255,0.04)", padding:6, borderRadius:30, border:"1px solid rgba(255,255,255,0.06)", flexWrap:"wrap", justifyContent:"center" }}>
        {Object.keys(screens).map(s=>(
          <button key={s} onClick={()=>{ setScreen(s); if(s==="discover")setNav("uni"); else if(s==="applications")setNav("apps"); else if(s==="copilot"||s==="chat")setNav("ai"); }} style={{
            padding:"7px 14px", borderRadius:18, border:"none",
            background: screen===s ? G.green : "transparent",
            color: screen===s ? G.black : "rgba(255,255,255,0.35)",
            fontWeight:800, cursor:"pointer", fontSize:11,
            transition:"all 0.2s", fontFamily:"inherit", letterSpacing:"0.02em",
          }}>{labels[s]}</button>
        ))}
      </div>

      {/* Phone */}
      <div style={{ width:360, height:740, background:G.black, borderRadius:48, overflow:"hidden", boxShadow:"0 60px 120px rgba(0,0,0,0.8), 0 0 0 1px rgba(255,255,255,0.06)", border:`7px solid #1A1A1A`, position:"relative", display:"flex", flexDirection:"column" }}>
        <div style={{ flex:1, overflow:"hidden", position:"relative" }}>
          {screens[screen]}
        </div>
      </div>
    </div>
  );
}

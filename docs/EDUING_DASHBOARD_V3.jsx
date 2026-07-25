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
};

function Badge({ label, color=G.green, bg }) {
  return (
    <div style={{
      display:"inline-flex", alignItems:"center",
      height:20, paddingLeft:8, paddingRight:8,
      borderRadius:10, background: bg||(color+"22"),
      border:`1px solid ${color}44`,
    }}>
      <span style={{ fontSize:9, fontWeight:900, color, letterSpacing:"0.08em" }}>{label}</span>
    </div>
  );
}

function ProgressBar({ value, color=G.green, height=4 }) {
  return (
    <div style={{ height, borderRadius:height/2, background:G.border, overflow:"hidden" }}>
      <div style={{ height:"100%", width:`${value}%`, borderRadius:height/2, background:color,
        boxShadow:`0 0 8px ${color}66`, transition:"width 0.5s" }}/>
    </div>
  );
}

function Card({ children, style={}, onClick, color }) {
  const [pressed, setPressed] = useState(false);
  return (
    <div onClick={onClick}
      onMouseDown={()=>onClick&&setPressed(true)}
      onMouseUp={()=>onClick&&setPressed(false)}
      onMouseLeave={()=>setPressed(false)}
      style={{
        background:G.surface, borderRadius:20,
        border:`1px solid ${color?color+"33":G.border}`,
        transform: pressed?"scale(0.97)":"scale(1)",
        transition:"transform 0.15s",
        cursor:onClick?"pointer":"default",
        overflow:"hidden",
        boxShadow: color?`0 4px 20px ${color}18`:"none",
        ...style,
      }}>
      {children}
    </div>
  );
}

// Notched card with floating action docked to corner
function NotchedCard({ children, bg=G.surface, notchColor=G.black, actionIcon, actionBg=G.green, actionColor=G.black, style={}, onAction }) {
  const [pressed, setPressed] = useState(false);
  return (
    <div style={{ position:"relative", ...style }}>
      <div style={{
        background:bg, borderRadius:20, padding:"20px",
        position:"relative", overflow:"hidden",
        boxShadow:`0 8px 32px rgba(0,0,0,0.4)`,
      }}>
        {children}
        {/* Corner clip for notch */}
        <div style={{
          position:"absolute", bottom:-20, right:-20,
          width:56, height:56, borderRadius:"50%",
          background:notchColor,
        }}/>
      </div>
      {/* Floating action */}
      {actionIcon && (
        <div
          onMouseDown={()=>setPressed(true)}
          onMouseUp={()=>setPressed(false)}
          onClick={onAction}
          style={{
            position:"absolute", bottom:-10, right:-10,
            width:48, height:48, borderRadius:24,
            background:actionBg,
            display:"flex", alignItems:"center", justifyContent:"center",
            fontSize:20, cursor:"pointer", zIndex:10,
            boxShadow:`0 6px 20px ${actionBg}66`,
            transform: pressed?"scale(0.9)":"scale(1)",
            transition:"transform 0.1s",
            color:actionColor, fontWeight:900,
          }}>{actionIcon}</div>
      )}
    </div>
  );
}

function FloatingNav({ active, onChange }) {
  const tabs = [
    { id:"home",  icon:"⊞", label:"Home"    },
    { id:"uni",   icon:"🏛", label:"Discover"},
    { id:"apps",  icon:"📋", label:"Apply"   },
    { id:"ai",    icon:"✦",  label:"Copilot" },
    { id:"plan",  icon:"📅", label:"Planner" },
  ];
  return (
    <div style={{
      position:"absolute", bottom:16, left:16, right:16, height:62,
      background:"rgba(26,26,26,0.95)",
      backdropFilter:"blur(20px)",
      borderRadius:31,
      border:`1px solid ${G.border}`,
      display:"flex", alignItems:"center", justifyContent:"space-around",
      padding:"0 6px", zIndex:50,
      boxShadow:"0 8px 32px rgba(0,0,0,0.6)",
    }}>
      {tabs.map(tab=>{
        const on = tab.id===active;
        return (
          <div key={tab.id} onClick={()=>onChange(tab.id)} style={{
            display:"flex", flexDirection:"column", alignItems:"center", gap:2,
            cursor:"pointer", padding:"6px 10px", borderRadius:18,
            background: on?"rgba(61,255,84,0.12)":"transparent",
            transition:"all 0.2s", minWidth:44,
          }}>
            <span style={{ fontSize:on?18:15, filter:on?"none":"grayscale(1) opacity(0.4)", transition:"all 0.2s" }}>{tab.icon}</span>
            {on && <span style={{ fontSize:8, fontWeight:900, color:G.green, letterSpacing:"0.04em" }}>{tab.label}</span>}
          </div>
        );
      })}
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// DASHBOARD SCREEN
// ══════════════════════════════════════════════════════════════
function DashboardScreen() {
  const [nav, setNav] = useState("home");

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column", position:"relative" }}>
      <div style={{ flex:1, overflowY:"auto", padding:"10px 18px 90px" }}>

        {/* ── HEADER ── */}
        <div style={{ display:"flex", alignItems:"center", justifyContent:"space-between", marginBottom:20 }}>
          <div>
            <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.12em", marginBottom:3 }}>GOOD MORNING</div>
            <div style={{ fontSize:22, fontWeight:900, color:G.white, letterSpacing:"-0.5px" }}>Aaryan Sharma 👋</div>
          </div>
          <div style={{ display:"flex", gap:10, alignItems:"center" }}>
            {/* Bell */}
            <div style={{ position:"relative", width:40, height:40, borderRadius:20, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer" }}>
              <span style={{ fontSize:18 }}>🔔</span>
              <div style={{ position:"absolute", top:8, right:8, width:8, height:8, borderRadius:4, background:G.green, border:`2px solid ${G.black}` }}/>
            </div>
            {/* Avatar */}
            <div style={{ width:40, height:40, borderRadius:20, background:`linear-gradient(135deg,${G.purple},${G.blue})`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:18, cursor:"pointer", border:`2px solid ${G.green}44` }}>👤</div>
          </div>
        </div>

        {/* ── READINESS HERO CARD ── */}
        <NotchedCard
          bg={`linear-gradient(135deg, ${G.purple} 0%, ${G.blue} 100%)`}
          notchColor={G.black}
          actionIcon="→"
          actionBg={G.green}
          actionColor={G.black}
          style={{ marginBottom:14 }}
        >
          <Badge label="ADMISSION READINESS" color="#fff" bg="rgba(255,255,255,0.15)"/>
          <div style={{ fontSize:52, fontWeight:900, color:"#fff", letterSpacing:"-2px", lineHeight:1, marginTop:10, marginBottom:4 }}>85%</div>
          <div style={{ fontSize:13, color:"rgba(255,255,255,0.65)", marginBottom:14 }}>4 tasks left · Fall 2027 admissions</div>
          <ProgressBar value={85} color="#fff" height={4}/>
          <div style={{ fontSize:12, color:"rgba(255,255,255,0.5)", marginTop:8 }}>Next: Upload IELTS Score</div>
        </NotchedCard>

        {/* ── STATS ROW ── */}
        <div style={{ display:"flex", gap:10, marginBottom:14 }}>
          {[
            { label:"Universities", value:"18", delta:"↑ +3", color:G.green  },
            { label:"Applications", value:"5",  delta:"2 active", color:G.blue   },
            { label:"Offers",       value:"2",  delta:"↑ new",    color:G.orange },
          ].map(s=>(
            <Card key={s.label} color={s.color} style={{ flex:1, padding:"14px 12px" }}>
              <div style={{ fontSize:9, fontWeight:800, color:G.white30, letterSpacing:"0.08em", marginBottom:6 }}>{s.label.toUpperCase()}</div>
              <div style={{ fontSize:24, fontWeight:900, color:G.white, letterSpacing:"-0.5px" }}>{s.value}</div>
              <Badge label={s.delta} color={s.color} style={{ marginTop:6 }}/>
            </Card>
          ))}
        </div>

        {/* ── ACTIVE APPLICATION ── */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:10 }}>ACTIVE APPLICATION</div>
        <NotchedCard
          bg={G.surface}
          notchColor={G.black}
          actionIcon="→"
          actionBg={G.blue}
          style={{ marginBottom:14 }}
        >
          <div style={{ display:"flex", alignItems:"flex-start", gap:12, marginBottom:14 }}>
            <div style={{ width:44, height:44, borderRadius:14, background:G.blue+"22", border:`1px solid ${G.blue}44`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:20, flexShrink:0 }}>🏛</div>
            <div style={{ flex:1 }}>
              <div style={{ fontSize:16, fontWeight:900, color:G.white, letterSpacing:"-0.3px" }}>BITS Pilani</div>
              <div style={{ fontSize:12, color:G.white60 }}>B.Tech CSE · Pilani Campus</div>
            </div>
            <Badge label="IN PROGRESS" color={G.blue}/>
          </div>
          <ProgressBar value={91} color={G.green} height={5}/>
          <div style={{ display:"flex", justifyContent:"space-between", marginTop:8 }}>
            <span style={{ fontSize:11, color:G.white30 }}>Deadline: Aug 30, 2025</span>
            <span style={{ fontSize:12, fontWeight:900, color:G.green }}>91%</span>
          </div>
        </NotchedCard>

        {/* ── QUICK ACTIONS ── */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:10 }}>QUICK ACTIONS</div>
        <div style={{ display:"flex", gap:8, marginBottom:16, flexWrap:"wrap" }}>
          {[
            { label:"SOP Builder",  icon:"📝", color:G.purple },
            { label:"Doc Vault",    icon:"🔐", color:G.blue   },
            { label:"Interview",    icon:"🎤", color:"#1C8A5E"},
            { label:"AI Copilot",   icon:"✦",  color:G.green  },
          ].map(a=>(
            <div key={a.label} style={{
              display:"flex", alignItems:"center", gap:6,
              height:36, paddingLeft:12, paddingRight:14,
              borderRadius:18,
              background:a.color+"18",
              border:`1.5px solid ${a.color}44`,
              cursor:"pointer",
            }}>
              <span style={{ fontSize:14 }}>{a.icon}</span>
              <span style={{ fontSize:12, fontWeight:800, color:a.color }}>{a.label}</span>
            </div>
          ))}
        </div>

        {/* ── UPCOMING TIMELINE ── */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:10 }}>UPCOMING DEADLINES</div>
        {[
          { title:"Passport Upload",      tag:"REQUIRED",  date:"Tomorrow",    color:G.red    },
          { title:"BITS Application",     tag:"IN 2 DAYS", date:"22 Jul 2025", color:G.yellow },
          { title:"Interview Round",      tag:"IN 5 DAYS", date:"25 Jul 2025", color:G.blue   },
          { title:"Stanford Application", tag:"DEADLINE",  date:"27 Jul 2025", color:G.orange },
        ].map((item,i)=>(
          <div key={i} style={{
            display:"flex", alignItems:"center", justifyContent:"space-between",
            padding:"14px 16px", marginBottom:8,
            background:G.surface, borderRadius:16,
            border:`1px solid ${item.color}22`,
          }}>
            <div style={{ display:"flex", alignItems:"center", gap:12 }}>
              <div style={{ width:4, height:36, borderRadius:2, background:item.color, boxShadow:`0 0 8px ${item.color}88` }}/>
              <div>
                <div style={{ fontSize:14, fontWeight:800, color:G.white }}>{item.title}</div>
                <div style={{ fontSize:11, color:G.white30, marginTop:2 }}>{item.date}</div>
              </div>
            </div>
            <Badge label={item.tag} color={item.color}/>
          </div>
        ))}

        {/* ── SCHOLARSHIPS ── */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", margin:"16px 0 10px" }}>SCHOLARSHIPS</div>
        <div style={{ display:"flex", gap:10 }}>
          {[
            { name:"STEM Innovators Grant", match:"94%", color:G.green  },
            { name:"Merit Excellence Fund",  match:"87%", color:G.purple },
          ].map((s,i)=>(
            <NotchedCard key={i} bg={G.surface} notchColor={G.black} actionIcon="→" actionBg={s.color} style={{ flex:1 }}>
              <div style={{ fontSize:10, fontWeight:800, color:s.color, letterSpacing:"0.06em", marginBottom:6 }}>MATCH</div>
              <div style={{ fontSize:20, fontWeight:900, color:G.white, marginBottom:4 }}>{s.match}</div>
              <div style={{ fontSize:11, color:G.white60, lineHeight:1.3 }}>{s.name}</div>
            </NotchedCard>
          ))}
        </div>

      </div>
      <FloatingNav active={nav} onChange={setNav}/>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// ROOT
// ══════════════════════════════════════════════════════════════
export default function App() {
  return (
    <div style={{
      minHeight:"100vh", background:"#050505",
      display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center",
      padding:40,
      fontFamily:"'SF Pro Display',-apple-system,BlinkMacSystemFont,sans-serif",
    }}>
      <style>{`*{box-sizing:border-box;margin:0;padding:0;}::-webkit-scrollbar{width:0;}input{font-family:inherit;}`}</style>

      {/* Phone */}
      <div style={{
        width:360, height:740,
        background:G.black,
        borderRadius:48,
        overflow:"hidden",
        boxShadow:"0 60px 120px rgba(0,0,0,0.8), 0 0 0 1px rgba(255,255,255,0.06)",
        border:`7px solid #1A1A1A`,
        position:"relative", display:"flex", flexDirection:"column",
      }}>
        {/* Status bar */}
        <div style={{ height:40, display:"flex", alignItems:"center", justifyContent:"space-between", padding:"0 22px", flexShrink:0 }}>
          <span style={{ fontSize:13, fontWeight:700, color:G.white }}>9:41</span>
          <div style={{ display:"flex", gap:4, alignItems:"center" }}>
            {[0.4,0.7,1].map((o,i)=><div key={i} style={{ width:3+i*0.5, height:6+i*2, background:G.white, borderRadius:1, opacity:o }}/>)}
            <div style={{ width:14, height:7, border:`1.5px solid ${G.white}`, borderRadius:3, marginLeft:3, position:"relative", opacity:0.8 }}>
              <div style={{ position:"absolute", left:1, top:1, right:2, bottom:1, background:G.white, borderRadius:1 }}/>
            </div>
          </div>
        </div>
        <div style={{ flex:1, overflow:"hidden", position:"relative" }}>
          <DashboardScreen/>
        </div>
      </div>
    </div>
  );
}

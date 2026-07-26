import { useState, useEffect, useRef } from "react";

const G = {
  green:   "#3DFF54", black:   "#0A0A0A", black2:  "#111111",
  surface: "#1A1A1A", surface2:"#222222", border:  "#2A2A2A",
  white:   "#FFFFFF", white60: "rgba(255,255,255,0.6)",
  white30: "rgba(255,255,255,0.3)", white10: "rgba(255,255,255,0.08)",
  purple:  "#7B5EA7", blue:    "#3B5BFF", orange:  "#FF6B35",
  yellow:  "#F5A623", red:     "#FF3B30", pink:    "#FF3B7A",
};

// ── SHARED ─────────────────────────────────────────────────────
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
      <div style={{ height:"100%", width:`${value}%`, borderRadius:height/2, background:color, boxShadow:`0 0 8px ${color}55`, transition:"width 0.6s ease" }}/>
    </div>
  );
}

function NotchedCard({ children, bg=G.surface, notchColor=G.black, actionIcon, actionBg=G.green, actionColor=G.black, style={}, onAction }) {
  const [p,setP]=useState(false);
  return (
    <div style={{ position:"relative", ...style }}>
      <div style={{ background:bg, borderRadius:20, padding:"18px", position:"relative", overflow:"hidden", boxShadow:"0 8px 24px rgba(0,0,0,0.4)" }}>
        {children}
        <div style={{ position:"absolute", bottom:-20, right:-20, width:52, height:52, borderRadius:"50%", background:notchColor }}/>
      </div>
      {actionIcon && (
        <div onMouseDown={()=>setP(true)} onMouseUp={()=>setP(false)} onClick={onAction}
          style={{ position:"absolute", bottom:-10, right:-10, width:44, height:44, borderRadius:22, background:actionBg, display:"flex", alignItems:"center", justifyContent:"center", fontSize:18, cursor:"pointer", zIndex:10, boxShadow:`0 6px 20px ${actionBg}55`, transform:p?"scale(0.9)":"scale(1)", transition:"transform 0.1s", color:actionColor, fontWeight:900 }}>
          {actionIcon}
        </div>
      )}
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

function BackHeader({ title, onBack, action }) {
  return (
    <div style={{ display:"flex", alignItems:"center", gap:12, padding:"6px 18px 0", marginBottom:4 }}>
      <div onClick={onBack} style={{ width:32, height:32, borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer" }}>
        <span style={{ color:G.white, fontSize:14 }}>←</span>
      </div>
      <span style={{ fontSize:12, fontWeight:800, color:G.white30, letterSpacing:"0.08em", flex:1 }}>{title}</span>
      {action}
    </div>
  );
}

function GreenBtn({ label, onClick, icon, small=false, disabled=false, ghost=false, full=false }) {
  const [p,setP]=useState(false);
  return (
    <button onClick={onClick} disabled={disabled}
      onMouseDown={()=>setP(true)} onMouseUp={()=>setP(false)}
      style={{ height:small?38:52, padding:`0 ${small?16:24}px`, borderRadius:small?19:26, width:full?"100%":"auto",
        background:disabled?"#2A2A2A":ghost?"transparent":G.green,
        color:disabled?G.white30:ghost?G.white:G.black,
        border:ghost?`1.5px solid ${G.border}`:"none",
        fontSize:small?13:15, fontWeight:800, cursor:disabled?"not-allowed":"pointer",
        display:"inline-flex", alignItems:"center", justifyContent:"center", gap:6,
        fontFamily:"inherit", transform:p?"scale(0.96)":"scale(1)", transition:"transform 0.1s",
        boxShadow:disabled||ghost?"none":`0 4px 20px ${G.green}44` }}>
      {icon && <span style={{ fontSize:small?14:17 }}>{icon}</span>}
      {label}
    </button>
  );
}

// ══════════════════════════════════════════════════════════════
// 1. APPLICATION DETAIL + TRACKER
// ══════════════════════════════════════════════════════════════
function AppDetailScreen({ setScreen }) {
  const steps = [
    { label:"Profile Complete",    done:true,  date:"Jul 10" },
    { label:"Documents Uploaded",  done:true,  date:"Jul 14" },
    { label:"Application Form",    done:true,  date:"Jul 18" },
    { label:"Payment",             done:false, active:true, date:"Pending" },
    { label:"Submitted",           done:false, date:"—"     },
    { label:"Under Review",        done:false, date:"—"     },
    { label:"Decision",            done:false, date:"—"     },
  ];

  const docs = [
    { name:"10th Marksheet",  status:"uploaded", color:G.green  },
    { name:"12th Marksheet",  status:"uploaded", color:G.green  },
    { name:"JEE Scorecard",   status:"uploaded", color:G.green  },
    { name:"Passport",        status:"missing",  color:G.red    },
    { name:"SOP",             status:"draft",    color:G.yellow },
    { name:"LOR (x2)",        status:"pending",  color:G.orange },
  ];

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <BackHeader title="APPLICATION DETAIL" onBack={()=>setScreen("applications")}
        action={<Badge label="IN PROGRESS" color={G.blue}/>}
      />
      <div style={{ flex:1, overflowY:"auto", padding:"16px 18px 28px" }}>

        {/* University header */}
        <div style={{ display:"flex", gap:14, alignItems:"center", marginBottom:18 }}>
          <div style={{ width:60, height:60, borderRadius:18, background:G.blue+"22", border:`1.5px solid ${G.blue}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:28, flexShrink:0 }}>🏛</div>
          <div>
            <div style={{ fontSize:20, fontWeight:900, color:G.white, letterSpacing:"-0.5px" }}>BITS Pilani</div>
            <div style={{ fontSize:13, color:G.white30 }}>B.Tech Computer Science · Pilani Campus</div>
            <div style={{ fontSize:12, color:G.yellow, fontWeight:700, marginTop:2 }}>⏰ Deadline: Aug 30, 2025</div>
          </div>
        </div>

        {/* Progress hero */}
        <NotchedCard bg={`linear-gradient(135deg,${G.blue},${G.purple})`} notchColor={G.black} actionIcon="→" actionBg={G.green} actionColor={G.black} style={{ marginBottom:18 }}>
          <div style={{ fontSize:10, fontWeight:800, color:"rgba(255,255,255,0.5)", letterSpacing:"0.1em", marginBottom:6 }}>APPLICATION PROGRESS</div>
          <div style={{ fontSize:48, fontWeight:900, color:"#fff", letterSpacing:"-2px", lineHeight:1, marginBottom:8 }}>91%</div>
          <ProgressBar value={91} color="rgba(255,255,255,0.9)" height={5}/>
          <div style={{ fontSize:13, color:"rgba(255,255,255,0.6)", marginTop:8 }}>1 action required · Payment pending</div>
        </NotchedCard>

        {/* Step tracker */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:12 }}>APPLICATION STEPS</div>
        <div style={{ background:G.surface, border:`1px solid ${G.border}`, borderRadius:20, padding:"16px", marginBottom:18 }}>
          {steps.map((s,i)=>(
            <div key={i} style={{ display:"flex", gap:14, alignItems:"flex-start", marginBottom:i<steps.length-1?16:0 }}>
              {/* Dot + line */}
              <div style={{ display:"flex", flexDirection:"column", alignItems:"center", flexShrink:0, width:28 }}>
                <div style={{
                  width:28, height:28, borderRadius:14,
                  background: s.done?G.green:s.active?G.purple:G.surface2,
                  border: s.active?`2px solid ${G.purple}`:s.done?"none":`2px solid ${G.border}`,
                  display:"flex", alignItems:"center", justifyContent:"center", fontSize:12, fontWeight:900,
                  color: s.done?G.black:s.active?"#fff":G.white30,
                  boxShadow: s.active?`0 0 16px ${G.purple}66`:s.done?`0 0 8px ${G.green}44`:"none",
                }}>
                  {s.done?"✓":s.active?"⟳":i+1}
                </div>
                {i<steps.length-1 && <div style={{ width:2, flex:1, minHeight:20, background:s.done?G.green:G.border, marginTop:4, boxShadow:s.done?`0 0 6px ${G.green}66`:"none" }}/>}
              </div>
              <div style={{ flex:1, paddingTop:4 }}>
                <div style={{ fontSize:14, fontWeight:800, color:s.done?G.white:s.active?G.purple:G.white30 }}>{s.label}</div>
                <div style={{ fontSize:11, color:s.done?G.green:s.active?G.yellow:G.white30, marginTop:2, fontWeight:600 }}>{s.date}</div>
              </div>
              {s.active && (
                <div style={{ paddingTop:4 }}>
                  <GreenBtn label="Pay Now" small onClick={()=>{}}/>
                </div>
              )}
            </div>
          ))}
        </div>

        {/* Required documents */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:12 }}>REQUIRED DOCUMENTS</div>
        {docs.map((d,i)=>(
          <div key={i} style={{ display:"flex", alignItems:"center", gap:12, padding:"12px 14px", marginBottom:8, background:G.surface, border:`1px solid ${d.color}22`, borderRadius:14 }}>
            <div style={{ width:36, height:36, borderRadius:12, background:d.color+"18", border:`1px solid ${d.color}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:16, flexShrink:0 }}>📄</div>
            <span style={{ flex:1, fontSize:14, fontWeight:700, color:G.white }}>{d.name}</span>
            <Badge label={d.status.toUpperCase()} color={d.color}/>
          </div>
        ))}

        {/* Actions */}
        <div style={{ display:"flex", gap:10, marginTop:16 }}>
          <GreenBtn label="Continue" onClick={()=>{}} full/>
        </div>
        <div style={{ marginTop:10 }}>
          <GreenBtn label="Withdraw Application" onClick={()=>{}} ghost full small/>
        </div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 2. NEW APPLICATION FORM
// ══════════════════════════════════════════════════════════════
function NewApplicationScreen({ setScreen }) {
  const [step, setStep] = useState(1);
  const [uni, setUni] = useState("");
  const [course, setCourse] = useState("");
  const [intake, setIntake] = useState("");
  const [loading, setLoading] = useState(false);

  const unis = ["BITS Pilani","IIT Bombay","Delhi University","VIT Vellore","NIT Trichy"];
  const courses = { "BITS Pilani":["B.Tech CSE","B.Tech EE","B.Tech Mech","B.E. Hons Chemistry"], "IIT Bombay":["B.Tech CSE","B.Tech Aerospace","B.Tech Electrical"], "Delhi University":["B.Sc CS","B.Sc Maths","BA Economics"], "VIT Vellore":["B.Tech CSE","B.Tech AI/ML","B.Tech Biotech"], "NIT Trichy":["B.Tech CSE","B.Tech Civil","B.Tech Mech"] };
  const intakes = ["July 2025","December 2025","July 2026"];

  const steps = ["University","Course","Intake","Confirm"];

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <BackHeader title="NEW APPLICATION" onBack={()=>step===1?setScreen("applications"):setStep(s=>s-1)}
        action={<Badge label={`${step}/4`} color={G.green}/>}
      />

      {/* Progress */}
      <div style={{ padding:"12px 18px 0" }}>
        <div style={{ display:"flex", gap:4, marginBottom:20 }}>
          {steps.map((_,i)=>(
            <div key={i} style={{ flex:1, height:3, borderRadius:2, background:i<step?G.green:G.border, boxShadow:i<step?`0 0 8px ${G.green}66`:"none", transition:"all 0.3s" }}/>
          ))}
        </div>
      </div>

      <div style={{ flex:1, overflowY:"auto", padding:"0 18px 24px" }}>

        {step===1 && (
          <>
            <h2 style={{ fontSize:24, fontWeight:900, color:G.white, letterSpacing:"-0.5px", marginBottom:6 }}>Pick a university.</h2>
            <p style={{ fontSize:13, color:G.white30, marginBottom:20 }}>Choose where you want to apply.</p>
            {unis.map(u=>(
              <div key={u} onClick={()=>setUni(u)} style={{ display:"flex", alignItems:"center", gap:12, padding:"14px 16px", marginBottom:10, background:G.surface, borderRadius:16, border:`1.5px solid ${uni===u?G.green:G.border}`, cursor:"pointer", boxShadow:uni===u?`0 0 16px ${G.green}18`:"none", transition:"all 0.2s" }}>
                <div style={{ width:36, height:36, borderRadius:12, background:uni===u?G.green+"22":G.surface2, border:`1px solid ${uni===u?G.green:G.border}`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:16, flexShrink:0 }}>🏛</div>
                <span style={{ fontSize:14, fontWeight:800, color:uni===u?G.green:G.white, flex:1 }}>{u}</span>
                {uni===u && <span style={{ color:G.green, fontSize:18 }}>✓</span>}
              </div>
            ))}
            <div style={{ marginTop:8 }}>
              <GreenBtn label="Continue →" onClick={()=>setStep(2)} disabled={!uni} full/>
            </div>
          </>
        )}

        {step===2 && (
          <>
            <h2 style={{ fontSize:24, fontWeight:900, color:G.white, letterSpacing:"-0.5px", marginBottom:6 }}>Choose a course.</h2>
            <p style={{ fontSize:13, color:G.white30, marginBottom:20 }}>Select the program you're applying for at {uni}.</p>
            {(courses[uni]||[]).map(c=>(
              <div key={c} onClick={()=>setCourse(c)} style={{ display:"flex", alignItems:"center", gap:12, padding:"14px 16px", marginBottom:10, background:G.surface, borderRadius:16, border:`1.5px solid ${course===c?G.blue:G.border}`, cursor:"pointer", transition:"all 0.2s" }}>
                <span style={{ fontSize:14, fontWeight:800, color:course===c?G.blue:G.white, flex:1 }}>{c}</span>
                {course===c && <span style={{ color:G.blue, fontSize:18 }}>✓</span>}
              </div>
            ))}
            <div style={{ marginTop:8 }}>
              <GreenBtn label="Continue →" onClick={()=>setStep(3)} disabled={!course} full/>
            </div>
          </>
        )}

        {step===3 && (
          <>
            <h2 style={{ fontSize:24, fontWeight:900, color:G.white, letterSpacing:"-0.5px", marginBottom:6 }}>Select intake.</h2>
            <p style={{ fontSize:13, color:G.white30, marginBottom:20 }}>When do you want to start?</p>
            {intakes.map(t=>(
              <div key={t} onClick={()=>setIntake(t)} style={{ display:"flex", alignItems:"center", gap:12, padding:"16px", marginBottom:10, background:G.surface, borderRadius:16, border:`1.5px solid ${intake===t?G.purple:G.border}`, cursor:"pointer", transition:"all 0.2s" }}>
                <div style={{ width:36, height:36, borderRadius:12, background:intake===t?G.purple+"22":G.surface2, display:"flex", alignItems:"center", justifyContent:"center", fontSize:16 }}>📅</div>
                <span style={{ fontSize:15, fontWeight:800, color:intake===t?G.purple:G.white, flex:1 }}>{t}</span>
                {intake===t && <span style={{ color:G.purple, fontSize:18 }}>✓</span>}
              </div>
            ))}
            <div style={{ marginTop:8 }}>
              <GreenBtn label="Continue →" onClick={()=>setStep(4)} disabled={!intake} full/>
            </div>
          </>
        )}

        {step===4 && (
          <>
            <h2 style={{ fontSize:24, fontWeight:900, color:G.white, letterSpacing:"-0.5px", marginBottom:20 }}>Confirm application.</h2>
            <div style={{ background:G.surface, border:`1px solid ${G.green}33`, borderRadius:20, padding:"20px", marginBottom:20 }}>
              {[["University",uni,G.green],["Course",course,G.blue],["Intake",intake,G.purple]].map(([l,v,c])=>(
                <div key={l} style={{ display:"flex", justifyContent:"space-between", alignItems:"center", marginBottom:14, paddingBottom:14, borderBottom:`1px solid ${G.border}` }}>
                  <span style={{ fontSize:12, fontWeight:800, color:G.white30, letterSpacing:"0.06em" }}>{l.toUpperCase()}</span>
                  <span style={{ fontSize:14, fontWeight:800, color:c }}>{v}</span>
                </div>
              ))}
              <div style={{ display:"flex", justifyContent:"space-between", alignItems:"center" }}>
                <span style={{ fontSize:12, fontWeight:800, color:G.white30, letterSpacing:"0.06em" }}>ESTIMATED DEADLINE</span>
                <span style={{ fontSize:14, fontWeight:800, color:G.yellow }}>Aug 30, 2025</span>
              </div>
            </div>
            <div style={{ background:G.yellow+"14", border:`1px solid ${G.yellow}33`, borderRadius:14, padding:"12px 14px", marginBottom:20 }}>
              <span style={{ fontSize:13, color:G.white60 }}>⚡ AI will auto-fill parts of your application from your profile and vault documents.</span>
            </div>
            <GreenBtn label={loading?"Creating...":"🚀 Start Application"} onClick={()=>{ setLoading(true); setTimeout(()=>{ setLoading(false); setScreen("appdetail"); },1500); }} full disabled={loading}/>
          </>
        )}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 3. DOCUMENT UPLOAD FLOW
// ══════════════════════════════════════════════════════════════
function DocUploadScreen({ setScreen }) {
  const [phase, setPhase] = useState("pick"); // pick | scan | crop | processing | done
  const [docType, setDocType] = useState("");
  const [quality, setQuality] = useState(null);

  const docTypes = [
    { label:"10th Marksheet",    icon:"📄", color:G.green  },
    { label:"12th Marksheet",    icon:"📄", color:G.green  },
    { label:"Entrance Scorecard",icon:"📊", color:G.blue   },
    { label:"Aadhaar Card",      icon:"🪪", color:G.purple },
    { label:"Passport",          icon:"📘", color:G.orange },
    { label:"Income Certificate",icon:"💰", color:G.yellow },
    { label:"SOP",               icon:"✍️", color:G.pink   },
    { label:"LOR",               icon:"📨", color:G.red    },
  ];

  const process = () => {
    setPhase("processing");
    setTimeout(()=>{ setQuality({ score:92, blur:"Clear", glare:"None", pages:"2/2", verdict:"PASSED" }); setPhase("done"); }, 2500);
  };

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <BackHeader title="UPLOAD DOCUMENT" onBack={()=>phase==="pick"?setScreen("vault"):setPhase("pick")}/>

      <div style={{ flex:1, overflowY:"auto", padding:"16px 18px 28px" }}>

        {phase==="pick" && (
          <>
            <h2 style={{ fontSize:22, fontWeight:900, color:G.white, letterSpacing:"-0.5px", marginBottom:6 }}>What are you uploading?</h2>
            <p style={{ fontSize:13, color:G.white30, marginBottom:20 }}>AI will verify and categorise automatically.</p>
            <div style={{ display:"grid", gridTemplateColumns:"1fr 1fr", gap:10, marginBottom:20 }}>
              {docTypes.map((d,i)=>(
                <div key={i} onClick={()=>setDocType(d.label)} style={{ padding:"14px", background:G.surface, border:`1.5px solid ${docType===d.label?d.color:G.border}`, borderRadius:16, cursor:"pointer", transition:"all 0.2s", boxShadow:docType===d.label?`0 0 16px ${d.color}22`:"none" }}>
                  <div style={{ fontSize:24, marginBottom:8 }}>{d.icon}</div>
                  <div style={{ fontSize:12, fontWeight:800, color:docType===d.label?d.color:G.white60, lineHeight:1.3 }}>{d.label}</div>
                  {docType===d.label && <div style={{ width:16, height:16, borderRadius:8, background:d.color, display:"flex", alignItems:"center", justifyContent:"center", fontSize:9, color:G.black, fontWeight:900, marginTop:6 }}>✓</div>}
                </div>
              ))}
            </div>

            {/* Upload options */}
            <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:12 }}>UPLOAD METHOD</div>
            <div style={{ display:"flex", flexDirection:"column", gap:10 }}>
              {[
                { icon:"📷", label:"Scan with Camera",   sub:"AI auto-crop + OCR",         color:G.green  },
                { icon:"🖼️", label:"Choose from Gallery", sub:"Select existing photo",       color:G.blue   },
                { icon:"📁", label:"Browse Files",        sub:"PDF, JPG, PNG supported",     color:G.purple },
              ].map((opt,i)=>(
                <div key={i} onClick={()=>docType&&setPhase("scan")} style={{ display:"flex", alignItems:"center", gap:14, padding:"16px", background:G.surface, border:`1.5px solid ${docType?opt.color+"44":G.border}`, borderRadius:16, cursor:docType?"pointer":"not-allowed", opacity:docType?1:0.5, transition:"all 0.2s" }}>
                  <div style={{ width:44, height:44, borderRadius:14, background:opt.color+"18", border:`1px solid ${opt.color}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:22, flexShrink:0 }}>{opt.icon}</div>
                  <div>
                    <div style={{ fontSize:14, fontWeight:800, color:G.white }}>{opt.label}</div>
                    <div style={{ fontSize:11, color:G.white30, marginTop:1 }}>{opt.sub}</div>
                  </div>
                  <span style={{ marginLeft:"auto", color:opt.color, fontSize:16 }}>→</span>
                </div>
              ))}
            </div>
          </>
        )}

        {phase==="scan" && (
          <>
            <h2 style={{ fontSize:20, fontWeight:900, color:G.white, marginBottom:16 }}>Position document</h2>
            {/* Camera viewfinder */}
            <div style={{ width:"100%", height:220, background:G.surface2, borderRadius:20, border:`2px solid ${G.green}`, position:"relative", overflow:"hidden", marginBottom:16, boxShadow:`0 0 24px ${G.green}33` }}>
              <div style={{ position:"absolute", inset:0, display:"flex", alignItems:"center", justifyContent:"center", flexDirection:"column", gap:8 }}>
                <span style={{ fontSize:48, opacity:0.4 }}>📄</span>
                <span style={{ fontSize:12, color:G.white30 }}>Align document within frame</span>
              </div>
              {/* Corner guides */}
              {[{top:12,left:12},{top:12,right:12},{bottom:12,left:12},{bottom:12,right:12}].map((pos,i)=>(
                <div key={i} style={{ position:"absolute", ...pos, width:24, height:24, border:`2.5px solid ${G.green}`, borderRadius:i===0?"4px 0 0 0":i===1?"0 4px 0 0":i===2?"0 0 0 4px":"0 0 4px 0" }}/>
              ))}
              {/* Live scan line */}
              <div style={{ position:"absolute", left:12, right:12, height:2, background:G.green, opacity:0.7, top:"50%", boxShadow:`0 0 8px ${G.green}`, animation:"scanline 2s ease-in-out infinite" }}/>
            </div>
            <div style={{ background:G.surface, border:`1px solid ${G.border}`, borderRadius:14, padding:"12px 14px", marginBottom:20 }}>
              <div style={{ display:"flex", gap:16 }}>
                {[["Auto-crop","✓","green"],["OCR","✓","green"],["Quality Check","✓","green"]].map(([l,v,c])=>(
                  <div key={l} style={{ display:"flex", alignItems:"center", gap:5 }}>
                    <span style={{ fontSize:12, color:G[c], fontWeight:900 }}>{v}</span>
                    <span style={{ fontSize:11, color:G.white30 }}>{l}</span>
                  </div>
                ))}
              </div>
            </div>
            <div style={{ display:"flex", gap:10 }}>
              <GreenBtn label="📷 Capture" onClick={()=>setPhase("crop")} full/>
            </div>
          </>
        )}

        {phase==="crop" && (
          <>
            <h2 style={{ fontSize:20, fontWeight:900, color:G.white, marginBottom:16 }}>Review & crop</h2>
            <div style={{ width:"100%", height:220, background:G.surface2, borderRadius:20, border:`1.5px solid ${G.border}`, position:"relative", overflow:"hidden", marginBottom:16, display:"flex", alignItems:"center", justifyContent:"center" }}>
              <span style={{ fontSize:64, opacity:0.3 }}>📄</span>
              {/* Crop handles */}
              <div style={{ position:"absolute", inset:20, border:`2px dashed ${G.green}`, borderRadius:8 }}/>
              {[{top:18,left:18},{top:18,right:18},{bottom:18,left:18},{bottom:18,right:18}].map((p,i)=>(
                <div key={i} style={{ position:"absolute", ...p, width:16, height:16, borderRadius:8, background:G.green, cursor:"grab" }}/>
              ))}
            </div>
            <div style={{ display:"flex", gap:10 }}>
              <GreenBtn label="Retake" onClick={()=>setPhase("scan")} ghost full small/>
              <GreenBtn label="✓ Use This" onClick={process} full small/>
            </div>
          </>
        )}

        {phase==="processing" && (
          <div style={{ display:"flex", flexDirection:"column", alignItems:"center", padding:"40px 0" }}>
            <div style={{ width:80, height:80, borderRadius:40, background:G.green+"22", border:`2px solid ${G.green}44`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:36, marginBottom:20, animation:"pulse 1.5s ease-in-out infinite" }}>✦</div>
            <div style={{ fontSize:18, fontWeight:900, color:G.white, marginBottom:8 }}>AI Processing...</div>
            <div style={{ fontSize:13, color:G.white30, marginBottom:32 }}>Checking quality, extracting text, verifying document</div>
            {["Checking blur & glare...","Detecting document type...","Extracting text via OCR...","Verifying authenticity..."].map((s,i)=>(
              <div key={i} style={{ display:"flex", alignItems:"center", gap:10, marginBottom:10, width:"100%", maxWidth:260 }}>
                <div style={{ width:18, height:18, borderRadius:9, background:G.green+"22", border:`1px solid ${G.green}44`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:9, color:G.green }}>✓</div>
                <span style={{ fontSize:12, color:G.white30 }}>{s}</span>
              </div>
            ))}
          </div>
        )}

        {phase==="done" && quality && (
          <>
            <div style={{ textAlign:"center", marginBottom:24 }}>
              <div style={{ width:72, height:72, borderRadius:36, background:G.green+"22", border:`2px solid ${G.green}`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:32, margin:"0 auto 14px" }}>✓</div>
              <div style={{ fontSize:22, fontWeight:900, color:G.white, marginBottom:4 }}>Document Verified!</div>
              <div style={{ fontSize:13, color:G.white30 }}>{docType} · AI Quality Score: {quality.score}/100</div>
            </div>

            <NotchedCard bg={`linear-gradient(135deg,#1C8A5E,${G.blue})`} notchColor={G.black} actionIcon="✓" actionBg={G.green} actionColor={G.black} style={{ marginBottom:18 }}>
              <div style={{ fontSize:10, fontWeight:800, color:"rgba(255,255,255,0.5)", letterSpacing:"0.1em", marginBottom:6 }}>AI QUALITY REPORT</div>
              <div style={{ fontSize:42, fontWeight:900, color:"#fff", letterSpacing:"-2px", lineHeight:1, marginBottom:10 }}>{quality.score}/100</div>
              <div style={{ display:"flex", gap:8, flexWrap:"wrap" }}>
                {[["Blur",quality.blur],["Glare",quality.glare],["Pages",quality.pages],["Verdict",quality.verdict]].map(([l,v])=>(
                  <div key={l} style={{ background:"rgba(255,255,255,0.15)", borderRadius:10, padding:"4px 10px" }}>
                    <span style={{ fontSize:10, fontWeight:800, color:"#fff" }}>{l}: {v}</span>
                  </div>
                ))}
              </div>
            </NotchedCard>

            <div style={{ display:"flex", gap:10 }}>
              <GreenBtn label="Upload Another" onClick={()=>{ setPhase("pick"); setDocType(""); setQuality(null); }} ghost full small/>
              <GreenBtn label="Go to Vault →" onClick={()=>setScreen("vault")} full small/>
            </div>
          </>
        )}
      </div>
      <style>{`@keyframes scanline{0%,100%{top:20%}50%{top:80%}}@keyframes pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.08)}}`}</style>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 4. NOTIFICATION CENTER
// ══════════════════════════════════════════════════════════════
function NotificationsScreen({ setScreen }) {
  const [filter, setFilter] = useState("All");
  const [read, setRead] = useState([]);
  const notifs = [
    { id:0,  icon:"⏰", title:"Application Deadline Tomorrow",  body:"BITS Pilani application closes Aug 30. Don't miss it!", time:"2 min ago",  color:G.red,    tag:"DEADLINE",  unread:true  },
    { id:1,  icon:"✦",  title:"AI Copilot Suggestion",          body:"Your SOP score improved to 88% after latest edits.",   time:"1 hr ago",   color:G.green,  tag:"AI",        unread:true  },
    { id:2,  icon:"🏆", title:"Scholarship Match Found",        body:"STEM Innovators Grant — 94% match with your profile.", time:"3 hrs ago",  color:G.yellow, tag:"SCHOLARSHIP",unread:true  },
    { id:3,  icon:"📄", title:"Document Verified",              body:"Your 12th Marksheet has been verified successfully.",   time:"Yesterday",  color:G.blue,   tag:"DOCUMENT",  unread:false },
    { id:4,  icon:"🏛",  title:"New University Added",          body:"Ashoka University is now on EDUING — check it out.",   time:"2 days ago", color:G.purple, tag:"DISCOVER",  unread:false },
    { id:5,  icon:"📋", title:"Application Status Update",      body:"IIT Bombay application moved to Under Review.",        time:"3 days ago", color:G.orange, tag:"APPLICATION",unread:false },
    { id:6,  icon:"🎤", title:"Interview Reminder",             body:"Mock interview session scheduled for today 4 PM.",     time:"4 days ago", color:G.pink,   tag:"INTERVIEW", unread:false },
  ];
  const tags = ["All","Deadline","AI","Scholarship","Document","Application"];
  const filtered = filter==="All" ? notifs : notifs.filter(n=>n.tag.toUpperCase()===filter.toUpperCase());
  const unreadCount = notifs.filter(n=>n.unread&&!read.includes(n.id)).length;

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <BackHeader title="NOTIFICATIONS" onBack={()=>setScreen("dashboard")}
        action={unreadCount>0&&<div onClick={()=>setRead(notifs.map(n=>n.id))} style={{ height:28, padding:"0 12px", borderRadius:14, background:G.green+"22", border:`1px solid ${G.green}44`, display:"flex", alignItems:"center", cursor:"pointer" }}>
          <span style={{ fontSize:10, fontWeight:800, color:G.green }}>Mark all read</span>
        </div>}
      />

      <div style={{ flex:1, overflowY:"auto", padding:"16px 18px 28px" }}>

        {/* Unread count */}
        {unreadCount>0 && (
          <div style={{ display:"flex", alignItems:"center", gap:8, marginBottom:16 }}>
            <div style={{ width:8, height:8, borderRadius:4, background:G.green, boxShadow:`0 0 8px ${G.green}` }}/>
            <span style={{ fontSize:13, fontWeight:800, color:G.white }}>{unreadCount} unread notifications</span>
          </div>
        )}

        {/* Filter chips */}
        <div style={{ display:"flex", gap:8, marginBottom:18, overflowX:"auto", paddingBottom:4 }}>
          {tags.map(t=>(
            <div key={t} onClick={()=>setFilter(t)} style={{ height:32, padding:"0 14px", borderRadius:16, cursor:"pointer", background:filter===t?G.green:G.surface, border:`1.5px solid ${filter===t?G.green:G.border}`, display:"flex", alignItems:"center", whiteSpace:"nowrap", transition:"all 0.2s" }}>
              <span style={{ fontSize:12, fontWeight:800, color:filter===t?G.black:G.white60 }}>{t}</span>
            </div>
          ))}
        </div>

        {/* Notification list */}
        {filtered.map((n,i)=>{
          const isRead = read.includes(n.id)||!n.unread;
          return (
            <div key={i} onClick={()=>setRead(p=>[...new Set([...p,n.id])])} style={{
              display:"flex", gap:12, padding:"14px 16px", marginBottom:10,
              background: isRead?G.surface:n.color+"0D",
              border:`1px solid ${isRead?G.border:n.color+"33"}`,
              borderRadius:16, cursor:"pointer",
              transition:"all 0.2s",
            }}>
              <div style={{ width:44, height:44, borderRadius:14, background:n.color+"18", border:`1.5px solid ${n.color}33`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:20, flexShrink:0, position:"relative" }}>
                {n.icon}
                {!isRead && <div style={{ position:"absolute", top:-3, right:-3, width:10, height:10, borderRadius:5, background:n.color, border:`2px solid ${G.black}` }}/>}
              </div>
              <div style={{ flex:1, minWidth:0 }}>
                <div style={{ display:"flex", justifyContent:"space-between", alignItems:"flex-start", marginBottom:4 }}>
                  <div style={{ fontSize:13, fontWeight:800, color:G.white, lineHeight:1.3, flex:1, marginRight:8 }}>{n.title}</div>
                  <Badge label={n.tag} color={n.color}/>
                </div>
                <div style={{ fontSize:12, color:G.white30, lineHeight:1.4, marginBottom:4 }}>{n.body}</div>
                <div style={{ fontSize:10, color:G.white30, fontWeight:600 }}>{n.time}</div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 5. PROFILE SETUP WIZARD (post-onboarding)
// ══════════════════════════════════════════════════════════════
function ProfileSetupScreen({ setScreen }) {
  const [step, setStep] = useState(1);
  const [data, setData] = useState({ name:"", dob:"", phone:"", board:"", pct12:"", jee:"", category:"General" });
  const totalSteps = 5;

  const set = (k,v) => setData(p=>({...p,[k]:v}));

  const Field = ({ label, placeholder, value, onChange, type="text" }) => {
    const [f,setF]=useState(false);
    return (
      <div style={{ marginBottom:14 }}>
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.08em", marginBottom:6 }}>{label}</div>
        <input type={type} placeholder={placeholder} value={value} onChange={e=>onChange(e.target.value)}
          onFocus={()=>setF(true)} onBlur={()=>setF(false)}
          style={{ width:"100%", height:52, background:G.surface, border:`1.5px solid ${f?G.green:G.border}`, borderRadius:14, padding:"0 16px", fontSize:14, color:G.white, outline:"none", fontFamily:"inherit", boxSizing:"border-box", transition:"all 0.2s", boxShadow:f?`0 0 0 3px ${G.green}14`:"none" }}/>
      </div>
    );
  };

  const stepContent = [
    { title:"Personal details.", sub:"Let's start with the basics." },
    { title:"Academic info.",    sub:"Your educational background." },
    { title:"Entrance exams.",   sub:"Test scores for admission matching." },
    { title:"Category & quota.", sub:"Helps match reservation-based seats." },
    { title:"You're all set!",   sub:"Profile complete — let's find universities." },
  ];
  const s = stepContent[step-1];

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <div style={{ padding:"6px 18px 0", display:"flex", alignItems:"center", gap:12, marginBottom:4 }}>
        {step>1 && <div onClick={()=>setStep(s=>s-1)} style={{ width:32, height:32, borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer" }}><span style={{ color:G.white, fontSize:14 }}>←</span></div>}
        <div style={{ flex:1, display:"flex", gap:4 }}>
          {Array.from({length:totalSteps}).map((_,i)=>(
            <div key={i} style={{ flex:1, height:3, borderRadius:2, background:i<step?G.green:G.border, boxShadow:i<step?`0 0 8px ${G.green}66`:"none", transition:"all 0.3s" }}/>
          ))}
        </div>
        <span style={{ fontSize:11, fontWeight:800, color:G.white30 }}>{step}/{totalSteps}</span>
      </div>

      <div style={{ flex:1, overflowY:"auto", padding:"20px 18px 28px" }}>
        <h2 style={{ fontSize:26, fontWeight:900, color:G.white, letterSpacing:"-0.5px", marginBottom:4 }}>{s.title}</h2>
        <p style={{ fontSize:13, color:G.white30, marginBottom:24 }}>{s.sub}</p>

        {step===1 && <>
          <Field label="FULL NAME" placeholder="Aaryan Sharma" value={data.name} onChange={v=>set("name",v)}/>
          <Field label="DATE OF BIRTH" placeholder="DD / MM / YYYY" value={data.dob} onChange={v=>set("dob",v)} type="date"/>
          <Field label="PHONE NUMBER" placeholder="+91 98765 43210" value={data.phone} onChange={v=>set("phone",v)} type="tel"/>
        </>}

        {step===2 && <>
          <div style={{ marginBottom:14 }}>
            <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.08em", marginBottom:8 }}>BOARD</div>
            <div style={{ display:"flex", gap:8 }}>
              {["CBSE","ICSE","State Board","IB"].map(b=>(
                <div key={b} onClick={()=>set("board",b)} style={{ flex:1, height:42, borderRadius:12, background:data.board===b?G.green+"22":G.surface, border:`1.5px solid ${data.board===b?G.green:G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", transition:"all 0.2s" }}>
                  <span style={{ fontSize:11, fontWeight:800, color:data.board===b?G.green:G.white30 }}>{b}</span>
                </div>
              ))}
            </div>
          </div>
          <Field label="12TH PERCENTAGE / CGPA" placeholder="95.4" value={data.pct12} onChange={v=>set("pct12",v)}/>
        </>}

        {step===3 && <>
          <Field label="JEE MAIN PERCENTILE" placeholder="99.2" value={data.jee} onChange={v=>set("jee",v)}/>
          <div style={{ background:G.surface, border:`1px solid ${G.border}`, borderRadius:14, padding:"14px 16px" }}>
            <div style={{ fontSize:12, fontWeight:800, color:G.white60, marginBottom:10 }}>OTHER EXAMS (optional)</div>
            {["BITSAT","MET","VITEEE","SRMJEEE"].map(e=>(
              <div key={e} style={{ display:"flex", alignItems:"center", gap:10, marginBottom:10 }}>
                <div style={{ width:20, height:20, borderRadius:10, border:`1.5px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", flexShrink:0 }}/>
                <span style={{ fontSize:13, color:G.white60 }}>{e}</span>
              </div>
            ))}
          </div>
        </>}

        {step===4 && <>
          <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.08em", marginBottom:10 }}>RESERVATION CATEGORY</div>
          <div style={{ display:"flex", flexDirection:"column", gap:8 }}>
            {["General","OBC-NCL","SC","ST","EWS","PwD"].map(c=>(
              <div key={c} onClick={()=>set("category",c)} style={{ display:"flex", alignItems:"center", gap:12, padding:"14px 16px", background:G.surface, border:`1.5px solid ${data.category===c?G.green:G.border}`, borderRadius:14, cursor:"pointer", transition:"all 0.2s" }}>
                <div style={{ width:20, height:20, borderRadius:10, border:`2px solid ${data.category===c?G.green:G.border}`, background:data.category===c?G.green:"transparent", display:"flex", alignItems:"center", justifyContent:"center", fontSize:10, color:G.black, fontWeight:900, flexShrink:0 }}>{data.category===c?"✓":""}</div>
                <span style={{ fontSize:14, fontWeight:700, color:data.category===c?G.green:G.white }}>{c}</span>
              </div>
            ))}
          </div>
        </>}

        {step===5 && (
          <div style={{ textAlign:"center", paddingTop:20 }}>
            <div style={{ fontSize:72, marginBottom:16 }}>🎉</div>
            <div style={{ fontSize:22, fontWeight:900, color:G.white, marginBottom:8 }}>Profile complete!</div>
            <div style={{ fontSize:14, color:G.white30, marginBottom:28, lineHeight:1.6 }}>
              EDUING AI has analysed your profile and found<br/>
              <span style={{ color:G.green, fontWeight:800 }}>18 universities</span> and <span style={{ color:G.yellow, fontWeight:800 }}>5 scholarships</span> for you.
            </div>
            <div style={{ background:G.surface, border:`1px solid ${G.green}33`, borderRadius:16, padding:"16px", marginBottom:24, textAlign:"left" }}>
              {[["Name",data.name||"Aaryan Sharma"],["Board",data.board||"CBSE"],["12th",data.pct12?`${data.pct12}%`:"95.4%"],["JEE",data.jee?`${data.jee} %ile`:"99.2 %ile"],["Category",data.category]].map(([l,v])=>(
                <div key={l} style={{ display:"flex", justifyContent:"space-between", marginBottom:10, paddingBottom:10, borderBottom:`1px solid ${G.border}` }}>
                  <span style={{ fontSize:12, fontWeight:800, color:G.white30 }}>{l}</span>
                  <span style={{ fontSize:13, fontWeight:800, color:G.white }}>{v}</span>
                </div>
              ))}
              <div style={{ display:"flex", justifyContent:"space-between" }}>
                <span style={{ fontSize:12, fontWeight:800, color:G.white30 }}>Readiness</span>
                <span style={{ fontSize:13, fontWeight:900, color:G.green }}>72% → improving</span>
              </div>
            </div>
          </div>
        )}

        <div style={{ marginTop:step===5?0:24 }}>
          <GreenBtn label={step===totalSteps?"🚀 Go to Dashboard":"Continue →"} onClick={()=>step<totalSteps?setStep(s=>s+1):setScreen("dashboard")} full disabled={step===1&&!data.name}/>
        </div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 6. PLANNER — CALENDAR VIEW
// ══════════════════════════════════════════════════════════════
function PlannerCalendarScreen({ setScreen }) {
  const [selectedDay, setSelectedDay] = useState(25);
  const month = "July 2025";
  const days = ["S","M","T","W","T","F","S"];
  const datesInMonth = Array.from({length:31},(_,i)=>i+1);
  const startOffset = 1; // July 2025 starts on Tuesday

  const events = {
    22:{ title:"BITS Application", color:G.blue,   tag:"DEADLINE" },
    24:{ title:"Mock Interview",   color:G.purple, tag:"HIGH"     },
    25:{ title:"Passport Upload",  color:G.red,    tag:"REQUIRED" },
    27:{ title:"Stanford Deadline",color:G.orange, tag:"DEADLINE" },
    29:{ title:"STEM Grant",       color:G.yellow, tag:"DEADLINE" },
    30:{ title:"JEE Form",         color:G.green,  tag:"MEDIUM"   },
  };

  const selectedEvents = Object.entries(events).filter(([d])=>parseInt(d)===selectedDay);

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <BackHeader title="CALENDAR" onBack={()=>setScreen("planner")}
        action={<div onClick={()=>setScreen("planner")} style={{ height:28, padding:"0 12px", borderRadius:14, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", cursor:"pointer" }}>
          <span style={{ fontSize:10, fontWeight:800, color:G.white60 }}>Timeline view</span>
        </div>}
      />

      <div style={{ flex:1, overflowY:"auto", padding:"16px 18px 28px" }}>

        {/* Month header */}
        <div style={{ display:"flex", alignItems:"center", justifyContent:"space-between", marginBottom:16 }}>
          <span style={{ fontSize:20, fontWeight:900, color:G.white }}>{month}</span>
          <div style={{ display:"flex", gap:8 }}>
            <div style={{ width:32, height:32, borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:14, color:G.white }}>‹</div>
            <div style={{ width:32, height:32, borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:14, color:G.white }}>›</div>
          </div>
        </div>

        {/* Day labels */}
        <div style={{ display:"grid", gridTemplateColumns:"repeat(7,1fr)", marginBottom:8 }}>
          {days.map((d,i)=>(
            <div key={i} style={{ textAlign:"center", fontSize:11, fontWeight:800, color:G.white30, padding:"4px 0" }}>{d}</div>
          ))}
        </div>

        {/* Calendar grid */}
        <div style={{ display:"grid", gridTemplateColumns:"repeat(7,1fr)", gap:4, marginBottom:24 }}>
          {Array.from({length:startOffset}).map((_,i)=><div key={`e${i}`}/>)}
          {datesInMonth.map(d=>{
            const hasEvent = events[d];
            const isSelected = d===selectedDay;
            const isToday = d===25;
            return (
              <div key={d} onClick={()=>setSelectedDay(d)} style={{
                height:40, borderRadius:12, display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center", cursor:"pointer",
                background: isSelected?G.green:isToday?G.green+"22":"transparent",
                border: isToday&&!isSelected?`1.5px solid ${G.green}`:"none",
                transition:"all 0.2s", position:"relative",
              }}>
                <span style={{ fontSize:13, fontWeight:800, color:isSelected?G.black:isToday?G.green:G.white }}>{d}</span>
                {hasEvent && !isSelected && (
                  <div style={{ width:5, height:5, borderRadius:3, background:hasEvent.color, position:"absolute", bottom:4, boxShadow:`0 0 4px ${hasEvent.color}` }}/>
                )}
              </div>
            );
          })}
        </div>

        {/* Selected day events */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:12 }}>
          {selectedDay ? `JULY ${selectedDay} EVENTS` : "SELECT A DATE"}
        </div>

        {selectedEvents.length>0 ? selectedEvents.map(([d,ev])=>(
          <div key={d} style={{ display:"flex", alignItems:"center", gap:12, padding:"14px 16px", marginBottom:10, background:G.surface, border:`1px solid ${ev.color}33`, borderRadius:16 }}>
            <div style={{ width:4, height:40, borderRadius:2, background:ev.color, flexShrink:0, boxShadow:`0 0 8px ${ev.color}88` }}/>
            <div style={{ flex:1 }}>
              <div style={{ fontSize:14, fontWeight:800, color:G.white }}>{ev.title}</div>
              <div style={{ fontSize:11, color:G.white30, marginTop:2 }}>July {d}, 2025</div>
            </div>
            <Badge label={ev.tag} color={ev.color}/>
          </div>
        )) : (
          <div style={{ textAlign:"center", padding:"24px 0", color:G.white30, fontSize:13 }}>
            No events on this day ✓
          </div>
        )}

        {/* Upcoming */}
        <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", margin:"16px 0 12px" }}>ALL UPCOMING</div>
        {Object.entries(events).sort((a,b)=>a[0]-b[0]).map(([d,ev])=>(
          <div key={d} onClick={()=>setSelectedDay(parseInt(d))} style={{ display:"flex", alignItems:"center", gap:10, padding:"10px 14px", marginBottom:8, background:G.surface, border:`1px solid ${G.border}`, borderRadius:12, cursor:"pointer" }}>
            <div style={{ width:32, height:32, borderRadius:10, background:ev.color+"18", border:`1px solid ${ev.color}33`, display:"flex", alignItems:"center", justifyContent:"center", flexShrink:0 }}>
              <span style={{ fontSize:11, fontWeight:900, color:ev.color }}>{d}</span>
            </div>
            <span style={{ fontSize:13, fontWeight:700, color:G.white, flex:1 }}>{ev.title}</span>
            <Badge label={ev.tag} color={ev.color}/>
          </div>
        ))}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// 7. STUDENT ID CARD — FULLSCREEN
// ══════════════════════════════════════════════════════════════
function StudentIDScreen({ setScreen }) {
  const [flipped, setFlipped] = useState(false);

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>
      <StatusBar/>
      <BackHeader title="STUDENT ID" onBack={()=>setScreen("profile")}
        action={<div style={{ display:"flex", gap:8 }}>
          <div style={{ width:32, height:32, borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:15 }}>📤</div>
          <div style={{ width:32, height:32, borderRadius:16, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:15 }}>⬇️</div>
        </div>}
      />

      <div style={{ flex:1, display:"flex", flexDirection:"column", alignItems:"center", padding:"24px 24px 28px" }}>

        {/* Flip toggle */}
        <div style={{ display:"flex", gap:8, marginBottom:28, background:G.surface, borderRadius:20, padding:4 }}>
          {["Front","Back"].map((t,i)=>(
            <div key={t} onClick={()=>setFlipped(i===1)} style={{ width:80, height:32, borderRadius:16, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", background:(i===1)===flipped?G.green:"transparent", transition:"all 0.2s" }}>
              <span style={{ fontSize:12, fontWeight:800, color:(i===1)===flipped?G.black:G.white30 }}>{t}</span>
            </div>
          ))}
        </div>

        {/* ID Card */}
        {!flipped ? (
          /* FRONT */
          <div style={{ width:"100%", maxWidth:320, borderRadius:24, overflow:"hidden", boxShadow:`0 20px 60px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,255,255,0.08)` }}>
            {/* Card header */}
            <div style={{ background:`linear-gradient(135deg,${G.purple},${G.blue})`, padding:"20px 20px 16px" }}>
              <div style={{ display:"flex", alignItems:"center", justifyContent:"space-between", marginBottom:16 }}>
                <div>
                  <div style={{ fontSize:10, fontWeight:900, color:"rgba(255,255,255,0.5)", letterSpacing:"0.15em" }}>EDUING</div>
                  <div style={{ fontSize:12, fontWeight:800, color:"rgba(255,255,255,0.8)" }}>Student Identity Card</div>
                </div>
                <div style={{ fontSize:32 }}>🎓</div>
              </div>
              {/* Avatar */}
              <div style={{ width:64, height:64, borderRadius:32, background:`linear-gradient(135deg,${G.purple}44,${G.blue}44)`, border:`3px solid rgba(255,255,255,0.3)`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:28, marginBottom:12 }}>👤</div>
              <div style={{ fontSize:20, fontWeight:900, color:"#fff", letterSpacing:"-0.3px" }}>Aaryan Sharma</div>
              <div style={{ fontSize:12, color:"rgba(255,255,255,0.6)", marginTop:2 }}>B.Tech Computer Science · 2025 Batch</div>
            </div>
            {/* Card body */}
            <div style={{ background:G.surface, padding:"16px 20px" }}>
              {[["Student ID","EDU-2025-78432"],["Email","aaryan@example.com"],["Category","General · JEE 99.2%ile"],["Valid Until","March 2026"]].map(([l,v])=>(
                <div key={l} style={{ display:"flex", justifyContent:"space-between", marginBottom:10, paddingBottom:10, borderBottom:`1px solid ${G.border}` }}>
                  <span style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.06em" }}>{l.toUpperCase()}</span>
                  <span style={{ fontSize:12, fontWeight:700, color:G.white }}>{v}</span>
                </div>
              ))}
              <div style={{ display:"flex", gap:8 }}>
                <Badge label="VERIFIED" color={G.green}/>
                <Badge label="2025 BATCH" color={G.blue}/>
                <Badge label="ACTIVE" color={G.green}/>
              </div>
            </div>
          </div>
        ) : (
          /* BACK */
          <div style={{ width:"100%", maxWidth:320, borderRadius:24, overflow:"hidden", boxShadow:`0 20px 60px rgba(0,0,0,0.6)`, background:G.surface }}>
            {/* QR section */}
            <div style={{ padding:"28px 20px", display:"flex", flexDirection:"column", alignItems:"center", borderBottom:`1px solid ${G.border}` }}>
              <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:16 }}>SCAN TO VERIFY</div>
              {/* QR code representation */}
              <div style={{ width:160, height:160, background:G.white, borderRadius:12, padding:10, display:"grid", gridTemplateColumns:"repeat(7,1fr)", gap:2 }}>
                {Array.from({length:49}).map((_,i)=>{
                  const isCorner = [0,1,7,8,5,6,12,13,35,36,42,43,40,41,47,48].includes(i);
                  const isFilled = isCorner || Math.random()>0.5;
                  return <div key={i} style={{ background:isFilled?"#000":"transparent", borderRadius:1 }}/>;
                })}
              </div>
              <div style={{ fontSize:11, fontWeight:700, color:G.white30, marginTop:12, letterSpacing:"0.05em" }}>EDU-2025-78432</div>
            </div>
            <div style={{ padding:"16px 20px" }}>
              <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:8 }}>IMPORTANT</div>
              <div style={{ fontSize:12, color:G.white30, lineHeight:1.6 }}>This card is for identity verification purposes. If found, please return to EDUING Help Centre. Misuse of this card is subject to disciplinary action.</div>
            </div>
          </div>
        )}

        {/* Share options */}
        <div style={{ marginTop:28, width:"100%" }}>
          <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:12, textAlign:"center" }}>SHARE VIA</div>
          <div style={{ display:"flex", gap:10, justifyContent:"center" }}>
            {[{icon:"📱",label:"WhatsApp"},{icon:"📧",label:"Email"},{icon:"🔗",label:"Link"},{icon:"📥",label:"Save"}].map(s=>(
              <div key={s.label} style={{ display:"flex", flexDirection:"column", alignItems:"center", gap:6, cursor:"pointer" }}>
                <div style={{ width:48, height:48, borderRadius:24, background:G.surface, border:`1px solid ${G.border}`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:20 }}>{s.icon}</div>
                <span style={{ fontSize:10, fontWeight:700, color:G.white30 }}>{s.label}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// ROOT
// ══════════════════════════════════════════════════════════════
export default function App() {
  const [screen, setScreen] = useState("appdetail");

  const screens = {
    appdetail:    <AppDetailScreen setScreen={setScreen}/>,
    newapp:       <NewApplicationScreen setScreen={setScreen}/>,
    docupload:    <DocUploadScreen setScreen={setScreen}/>,
    notifications:<NotificationsScreen setScreen={setScreen}/>,
    profilesetup: <ProfileSetupScreen setScreen={setScreen}/>,
    calendar:     <PlannerCalendarScreen setScreen={setScreen}/>,
    studentid:    <StudentIDScreen setScreen={setScreen}/>,
  };

  const labels={appdetail:"App Detail",newapp:"New App",docupload:"Doc Upload",notifications:"Notifications",profilesetup:"Profile Setup",calendar:"Calendar",studentid:"Student ID"};

  return (
    <div style={{ minHeight:"100vh", background:"#050505", display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center", padding:40, gap:28, fontFamily:"'SF Pro Display',-apple-system,BlinkMacSystemFont,sans-serif" }}>
      <style>{`*{box-sizing:border-box;margin:0;padding:0;}::-webkit-scrollbar{width:0;}input,textarea,select{font-family:inherit;}input::placeholder,textarea::placeholder{color:rgba(255,255,255,0.2);}@keyframes scanline{0%,100%{top:20%}50%{top:80%}}@keyframes pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.08)}}`}</style>

      <div style={{ display:"flex", gap:6, background:"rgba(255,255,255,0.04)", padding:6, borderRadius:30, border:"1px solid rgba(255,255,255,0.06)", flexWrap:"wrap", justifyContent:"center" }}>
        {Object.keys(screens).map(s=>(
          <button key={s} onClick={()=>setScreen(s)} style={{ padding:"7px 14px", borderRadius:18, border:"none", background:screen===s?G.green:"transparent", color:screen===s?G.black:"rgba(255,255,255,0.35)", fontWeight:800, cursor:"pointer", fontSize:11, transition:"all 0.2s", fontFamily:"inherit", letterSpacing:"0.02em" }}>{labels[s]}</button>
        ))}
      </div>

      <div style={{ width:360, height:740, background:G.black, borderRadius:48, overflow:"hidden", boxShadow:"0 60px 120px rgba(0,0,0,0.8), 0 0 0 1px rgba(255,255,255,0.06)", border:`7px solid #1A1A1A`, position:"relative", display:"flex", flexDirection:"column" }}>
        <div style={{ flex:1, overflow:"hidden", position:"relative" }}>
          {screens[screen]}
        </div>
      </div>
    </div>
  );
}

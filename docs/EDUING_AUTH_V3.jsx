import { useState, useEffect } from "react";

// ── TOKENS ─────────────────────────────────────────────────────
const G = {
  green:   "#3DFF54",
  black:   "#0A0A0A",
  black2:  "#111111",
  surface: "#1A1A1A",
  border:  "#2A2A2A",
  white:   "#FFFFFF",
  white60: "rgba(255,255,255,0.6)",
  white30: "rgba(255,255,255,0.3)",
  white10: "rgba(255,255,255,0.08)",
};

// ── STICKER CARD ───────────────────────────────────────────────
function Sticker({ label, sub, rotate, x, y, color="#fff", bg="#1A1A1A", size="md" }) {
  const w = size==="sm" ? 90 : 110;
  return (
    <div style={{
      position:"absolute", left:x, top:y,
      width:w, background:bg,
      borderRadius:16, padding:"8px 10px",
      transform:`rotate(${rotate}deg)`,
      boxShadow:"0 8px 24px rgba(0,0,0,0.4)",
      border:`1.5px solid rgba(255,255,255,0.1)`,
      userSelect:"none",
    }}>
      <div style={{ width:28, height:28, borderRadius:"50%", background:G.green+"33", marginBottom:5, overflow:"hidden", display:"flex", alignItems:"center", justifyContent:"center", fontSize:14 }}>🏛</div>
      <div style={{ fontSize:10, fontWeight:800, color, lineHeight:1.2, marginBottom:2 }}>{label}</div>
      {sub && <div style={{ fontSize:9, color:"rgba(255,255,255,0.4)", fontWeight:600 }}>{sub}</div>}
    </div>
  );
}

// ── PHONE FRAME ────────────────────────────────────────────────
function Phone({ children, label }) {
  return (
    <div style={{ display:"flex", flexDirection:"column", alignItems:"center", gap:12 }}>
      <div style={{
        width:360, height:740,
        background:G.black,
        borderRadius:48,
        overflow:"hidden",
        boxShadow:"0 60px 120px rgba(0,0,0,0.8), 0 0 0 1px rgba(255,255,255,0.06)",
        border:`7px solid #1A1A1A`,
        position:"relative", display:"flex", flexDirection:"column",
        fontFamily:"'SF Pro Display',-apple-system,BlinkMacSystemFont,sans-serif",
      }}>
        {/* Status bar */}
        <div style={{ height:40, display:"flex", alignItems:"center", justifyContent:"space-between", padding:"0 22px", flexShrink:0, zIndex:10, position:"relative" }}>
          <span style={{ fontSize:13, fontWeight:700, color:G.white }}>9:41</span>
          <div style={{ display:"flex", gap:4, alignItems:"center" }}>
            {[0.4,0.7,1].map((o,i)=><div key={i} style={{ width:3+i*0.5, height:6+i*2, background:G.white, borderRadius:1, opacity:o }}/>)}
            <div style={{ width:14, height:7, border:`1.5px solid ${G.white}`, borderRadius:3, marginLeft:3, position:"relative", opacity:0.8 }}>
              <div style={{ position:"absolute", left:1, top:1, right:2, bottom:1, background:G.white, borderRadius:1 }}/>
            </div>
          </div>
        </div>
        <div style={{ flex:1, overflow:"hidden", position:"relative" }}>
          {children}
        </div>
      </div>
      {label && <span style={{ fontSize:11, fontWeight:800, color:"#555", letterSpacing:"0.06em", textTransform:"uppercase" }}>{label}</span>}
    </div>
  );
}

// ── GREEN BUTTON ───────────────────────────────────────────────
function GreenBtn({ label, onClick, icon, outline=false, loading=false }) {
  const [pressed, setPressed] = useState(false);
  return (
    <button onClick={onClick}
      onMouseDown={()=>setPressed(true)}
      onMouseUp={()=>setPressed(false)}
      onMouseLeave={()=>setPressed(false)}
      style={{
        width:"100%", height:52, borderRadius:26,
        background: outline ? "transparent" : G.green,
        color: outline ? G.white : G.black,
        border: outline ? `1.5px solid ${G.border}` : "none",
        fontSize:15, fontWeight:800, cursor:"pointer",
        display:"flex", alignItems:"center", justifyContent:"center", gap:8,
        fontFamily:"inherit", letterSpacing:"0.01em",
        transform: pressed ? "scale(0.96)" : "scale(1)",
        transition:"transform 0.1s",
        boxShadow: outline ? "none" : `0 6px 24px ${G.green}44`,
      }}>
      {icon && <span style={{ fontSize:17 }}>{icon}</span>}
      {loading ? <span style={{ animation:"spin 1s linear infinite", display:"inline-block" }}>⟳</span> : label}
    </button>
  );
}

// ── GHOST BUTTON ───────────────────────────────────────────────
function GhostBtn({ label, icon, onClick }) {
  return (
    <button onClick={onClick} style={{
      width:"100%", height:50, borderRadius:25,
      background:G.white10, border:"none",
      color:G.white, fontSize:14, fontWeight:700,
      cursor:"pointer", display:"flex", alignItems:"center", justifyContent:"center", gap:8,
      fontFamily:"inherit",
      backdropFilter:"blur(10px)",
    }}>
      {icon && <span style={{ fontSize:16 }}>{icon}</span>}
      {label}
    </button>
  );
}

// ══════════════════════════════════════════════════════════════
// SPLASH SCREEN
// ══════════════════════════════════════════════════════════════
function SplashScreen({ onNavigate }) {
  const slides = [
    { bg:G.green,    textColor:G.black, accentColor:G.black, headline:["Your","journey","starts","now."] },
    { bg:"#FF6B35",  textColor:G.white, accentColor:G.green, headline:["Chase","dreams","not","limits."] },
    { bg:G.black,    textColor:G.white, accentColor:G.green, headline:["Apply","smarter,","get","in."]   },
  ];
  const [idx, setIdx] = useState(0);
  const s = slides[idx];

  useEffect(()=>{
    const t = setTimeout(()=>{ if(idx<slides.length-1) setIdx(i=>i+1); }, 3000);
    return ()=>clearTimeout(t);
  },[idx]);

  return (
    <div style={{ height:"100%", background:s.bg, display:"flex", flexDirection:"column", position:"relative", transition:"background 0.5s" }}>

      {/* Back arrow */}
      {idx>0 && (
        <div onClick={()=>setIdx(i=>i-1)} style={{ position:"absolute", top:10, left:20, zIndex:20, cursor:"pointer" }}>
          <div style={{ width:32, height:32, borderRadius:16, background:"rgba(0,0,0,0.2)", display:"flex", alignItems:"center", justifyContent:"center" }}>
            <span style={{ color: idx===1?G.white:G.black, fontSize:16 }}>←</span>
          </div>
        </div>
      )}

      {/* EDUING logo top */}
      <div style={{ padding:"10px 20px 0", zIndex:10 }}>
        <div style={{ fontSize:12, fontWeight:900, color: idx===0?G.black:G.white, letterSpacing:"0.15em", opacity:0.5 }}>EDUING</div>
      </div>

      {/* Hero headline */}
      <div style={{ padding:"16px 22px 0", flex:1, position:"relative" }}>
        <h1 style={{
          fontSize:52, fontWeight:900, lineHeight:1.05,
          letterSpacing:"-1.5px", margin:0,
          color: s.textColor,
          transition:"color 0.5s",
        }}>
          {s.headline.slice(0,3).join("\n")}
          <br/>
          <span style={{ color: idx===0 ? G.black : s.accentColor, fontStyle:"italic" }}>
            {s.headline[3]}
          </span>
        </h1>

        {/* Floating sticker cards */}
        <div style={{ position:"relative", height:180, marginTop:20 }}>
          <Sticker label="IIT Bombay" sub="#Most Visited" rotate={-8} x="5%" y="10px" bg={idx===0?"#1A1A1A":"rgba(0,0,0,0.4)"}/>
          <Sticker label="BITS Pilani" sub="#Top Match" rotate={5} x="38%" y="30px" bg={idx===0?"#222":"rgba(0,0,0,0.4)"} size="sm"/>
          <Sticker label="Delhi Uni" sub="#NIRF #3" rotate={-3} x="60%" y="5px" bg={idx===0?"#1A1A1A":"rgba(0,0,0,0.4)"} size="sm"/>
          <Sticker label="VIT Vellore" sub="#Engineering" rotate={7} x="8%" y="90px" bg={idx===0?"#333":"rgba(0,0,0,0.4)"} size="sm"/>
          <Sticker label="NIT Trichy" sub="#South India" rotate={-5} x="45%" y="100px" bg={G.green} color={G.black}/>
        </div>

        {/* Dot indicator */}
        <div style={{ display:"flex", gap:6, marginTop:8 }}>
          {slides.map((_,i)=>(
            <div key={i} onClick={()=>setIdx(i)} style={{
              height:4, borderRadius:2,
              width: i===idx ? 24 : 6,
              background: idx===0 ? (i===idx?"#000":"rgba(0,0,0,0.25)") : (i===idx?G.green:G.white30),
              cursor:"pointer", transition:"all 0.3s",
            }}/>
          ))}
        </div>
      </div>

      {/* Bottom auth actions */}
      <div style={{
        padding:"16px 22px 28px",
        background: idx===0
          ? "linear-gradient(0deg, rgba(0,0,0,0.12) 0%, transparent 100%)"
          : "linear-gradient(0deg, rgba(0,0,0,0.5) 0%, transparent 100%)",
        display:"flex", flexDirection:"column", gap:10, zIndex:10,
      }}>
        {/* Continue as guest */}
        <div onClick={()=>onNavigate("home")} style={{
          display:"flex", alignItems:"center", justifyContent:"center", gap:6,
          height:40, cursor:"pointer",
        }}>
          <div style={{ width:16, height:16, borderRadius:8, border:`1.5px solid ${idx===0?"rgba(0,0,0,0.4)":G.white30}`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:8, color:idx===0?"rgba(0,0,0,0.5)":G.white60 }}>👤</div>
          <span style={{ fontSize:13, fontWeight:700, color:idx===0?"rgba(0,0,0,0.6)":G.white60 }}>Continue As Guest</span>
        </div>

        {/* Apple */}
        <GreenBtn label="Continue with Apple" icon="🍎" onClick={()=>onNavigate("register")}/>

        {/* Google */}
        <GhostBtn label="Continue with Google" icon="G" onClick={()=>onNavigate("register")}/>

        <p style={{ textAlign:"center", fontSize:13, color:idx===0?"rgba(0,0,0,0.5)":G.white60, margin:0 }}>
          Already have an account?{" "}
          <span onClick={()=>onNavigate("login")} style={{ fontWeight:800, color:idx===0?G.black:G.white, cursor:"pointer", textDecoration:"underline" }}>Log in</span>
        </p>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// LOGIN SCREEN
// ══════════════════════════════════════════════════════════════
function LoginScreen({ onNavigate }) {
  const [email, setEmail] = useState("");
  const [pass, setPass] = useState("");
  const [loading, setLoading] = useState(false);
  const [showPass, setShowPass] = useState(false);

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column", padding:"0 22px 28px", overflowY:"auto" }}>

      {/* Back */}
      <div style={{ display:"flex", alignItems:"center", gap:12, paddingTop:6, marginBottom:32 }}>
        <div onClick={()=>onNavigate("splash")} style={{ width:32, height:32, borderRadius:16, background:G.surface, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer" }}>
          <span style={{ color:G.white, fontSize:14 }}>←</span>
        </div>
        <span style={{ fontSize:13, fontWeight:700, color:G.white60, letterSpacing:"0.04em" }}>SIGN IN</span>
      </div>

      {/* Progress bar */}
      <div style={{ height:3, background:G.surface, borderRadius:2, marginBottom:32 }}>
        <div style={{ height:"100%", width:"33%", background:G.green, borderRadius:2 }}/>
      </div>

      {/* Headline */}
      <h1 style={{ fontSize:38, fontWeight:900, color:G.white, letterSpacing:"-1px", lineHeight:1.1, marginBottom:8 }}>
        Welcome<br/>back.
      </h1>
      <p style={{ fontSize:14, color:G.white60, marginBottom:32 }}>Sign in to continue your admission journey.</p>

      {/* Social */}
      <div style={{ display:"flex", flexDirection:"column", gap:10, marginBottom:24 }}>
        <GreenBtn label="Continue with Apple" icon="🍎" onClick={()=>{}}/>
        <GhostBtn label="Continue with Google" icon="G" onClick={()=>{}}/>
      </div>

      {/* Divider */}
      <div style={{ display:"flex", alignItems:"center", gap:12, marginBottom:20 }}>
        <div style={{ flex:1, height:1, background:G.border }}/>
        <span style={{ fontSize:11, fontWeight:800, color:G.white30, letterSpacing:"0.08em" }}>OR</span>
        <div style={{ flex:1, height:1, background:G.border }}/>
      </div>

      {/* Email */}
      <EmailField label="EMAIL" placeholder="you@example.com" value={email} onChange={e=>setEmail(e.target.value)} type="email"/>
      <EmailField label="PASSWORD" placeholder="••••••••" value={pass} onChange={e=>setPass(e.target.value)} type={showPass?"text":"password"}
        right={<span onClick={()=>setShowPass(!showPass)} style={{ fontSize:14, cursor:"pointer", color:G.white60 }}>{showPass?"🙈":"👁"}</span>}
      />

      <div style={{ textAlign:"right", marginBottom:28, marginTop:-4 }}>
        <span onClick={()=>onNavigate("forgot")} style={{ fontSize:13, fontWeight:700, color:G.green, cursor:"pointer" }}>Forgot password?</span>
      </div>

      <div style={{ marginTop:"auto" }}>
        <GreenBtn label="Sign in" onClick={()=>{ setLoading(true); setTimeout(()=>{ setLoading(false); onNavigate("otp"); },1200); }} loading={loading} disabled={!email||!pass}/>
        <p style={{ textAlign:"center", fontSize:13, color:G.white60, marginTop:20 }}>
          No account?{" "}
          <span onClick={()=>onNavigate("register")} style={{ color:G.white, fontWeight:800, cursor:"pointer", textDecoration:"underline" }}>Create one →</span>
        </p>
      </div>
    </div>
  );
}

// ── INPUT FIELD ────────────────────────────────────────────────
function EmailField({ label, placeholder, value, onChange, type="text", right }) {
  const [focused, setFocused] = useState(false);
  return (
    <div style={{ marginBottom:14 }}>
      <div style={{ fontSize:10, fontWeight:800, color:G.white30, letterSpacing:"0.1em", marginBottom:6 }}>{label}</div>
      <div style={{ position:"relative" }}>
        <input type={type} placeholder={placeholder} value={value} onChange={onChange}
          onFocus={()=>setFocused(true)} onBlur={()=>setFocused(false)}
          style={{
            width:"100%", height:52, background:G.surface,
            border:`1.5px solid ${focused?G.green:G.border}`,
            borderRadius:14, padding:"0 44px 0 16px",
            fontSize:15, color:G.white, outline:"none",
            fontFamily:"inherit", boxSizing:"border-box",
            transition:"border-color 0.2s",
            boxShadow: focused?`0 0 0 3px ${G.green}18`:"none",
          }}/>
        {right && <div style={{ position:"absolute", right:14, top:"50%", transform:"translateY(-50%)" }}>{right}</div>}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// REGISTER SCREEN
// ══════════════════════════════════════════════════════════════
function RegisterScreen({ onNavigate }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [pass, setPass] = useState("");
  const [loading, setLoading] = useState(false);

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column", padding:"0 22px 28px", overflowY:"auto" }}>
      <div style={{ display:"flex", alignItems:"center", gap:12, paddingTop:6, marginBottom:24 }}>
        <div onClick={()=>onNavigate("splash")} style={{ width:32, height:32, borderRadius:16, background:G.surface, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer" }}>
          <span style={{ color:G.white, fontSize:14 }}>←</span>
        </div>
        <span style={{ fontSize:13, fontWeight:700, color:G.white60, letterSpacing:"0.04em" }}>CREATE ACCOUNT</span>
      </div>

      {/* Progress */}
      <div style={{ height:3, background:G.surface, borderRadius:2, marginBottom:28 }}>
        <div style={{ height:"100%", width:"66%", background:G.green, borderRadius:2 }}/>
      </div>

      <h1 style={{ fontSize:36, fontWeight:900, color:G.white, letterSpacing:"-1px", lineHeight:1.1, marginBottom:6 }}>
        Create account,<br/>
        <span style={{ color:G.green }}>start exploring.</span>
      </h1>
      <p style={{ fontSize:14, color:G.white60, marginBottom:28 }}>Join thousands of students getting into top universities.</p>

      <EmailField label="FULL NAME" placeholder="Aaryan Sharma" value={name} onChange={e=>setName(e.target.value)}/>
      <EmailField label="EMAIL" placeholder="you@example.com" value={email} onChange={e=>setEmail(e.target.value)} type="email"/>
      <EmailField label="PASSWORD" placeholder="Min. 8 characters" value={pass} onChange={e=>setPass(e.target.value)} type="password"/>

      {/* Password strength */}
      {pass.length>0 && (
        <div style={{ marginTop:-6, marginBottom:14 }}>
          <div style={{ display:"flex", gap:4 }}>
            {[1,2,3].map(i=>{
              const strength = pass.length<6?1:pass.length<10?2:3;
              const colors = ["#FF3B30","#F5A623",G.green];
              return <div key={i} style={{ flex:1, height:3, borderRadius:2, background: i<=strength?colors[strength-1]:G.border, transition:"all 0.3s" }}/>;
            })}
          </div>
        </div>
      )}

      <p style={{ fontSize:11, color:G.white30, lineHeight:1.6, marginBottom:20 }}>
        By continuing you agree to our <span style={{ color:G.green }}>Terms</span> & <span style={{ color:G.green }}>Privacy Policy</span>.
      </p>

      <div style={{ marginTop:"auto" }}>
        <GreenBtn label="Create Account" onClick={()=>{ setLoading(true); setTimeout(()=>{ setLoading(false); onNavigate("otp"); },1200); }} loading={loading} disabled={!name||!email||pass.length<8}/>
        <div style={{ display:"flex", flexDirection:"column", gap:10, marginTop:12 }}>
          <GhostBtn label="Continue with Apple" icon="🍎"/>
          <GhostBtn label="Continue with Google" icon="G"/>
        </div>
        <p style={{ textAlign:"center", fontSize:13, color:G.white60, marginTop:16 }}>
          Already have an account?{" "}
          <span onClick={()=>onNavigate("login")} style={{ color:G.white, fontWeight:800, cursor:"pointer", textDecoration:"underline" }}>Log in</span>
        </p>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// OTP / VERIFICATION SCREEN
// ══════════════════════════════════════════════════════════════
function OTPScreen({ onNavigate }) {
  const [digits, setDigits] = useState(["4","3","9","3"]);
  const [loading, setLoading] = useState(false);

  const handleNum = (n) => {
    const filled = digits.filter(d=>d!=="").length;
    if(n==="del") {
      const newD = [...digits];
      for(let i=3;i>=0;i--){ if(newD[i]!==""){ newD[i]=""; break; } }
      setDigits(newD);
    } else if(filled < 4) {
      const newD = [...digits];
      for(let i=0;i<4;i++){ if(newD[i]===""){ newD[i]=n; break; } }
      setDigits(newD);
    }
  };

  const numpad = [
    ["1","2","3"],
    ["4","5","6"],
    ["7","8","9"],
    [null,"0","del"],
  ];

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column" }}>

      {/* Header */}
      <div style={{ padding:"6px 22px 0", display:"flex", alignItems:"center", gap:10 }}>
        <div onClick={()=>onNavigate("register")} style={{ width:28, height:28, borderRadius:14, background:G.surface, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer" }}>
          <span style={{ color:G.white, fontSize:12 }}>←</span>
        </div>
        <span style={{ fontSize:11, fontWeight:800, color:G.white60, letterSpacing:"0.05em" }}>VERIFICATION</span>
      </div>

      {/* Green progress bar — full width, like the reference */}
      <div style={{ height:4, background:G.surface, margin:"12px 0 0" }}>
        <div style={{ height:"100%", width:"90%", background:G.green, borderRadius:"0 2px 2px 0",
          boxShadow:`0 0 12px ${G.green}88` }}/>
      </div>

      {/* Content */}
      <div style={{ padding:"24px 22px 0", flex:1 }}>
        <h1 style={{ fontSize:34, fontWeight:900, color:G.white, letterSpacing:"-0.8px", lineHeight:1.1, marginBottom:12 }}>
          Enter<br/>Verification<br/>Code
        </h1>
        <p style={{ fontSize:13, color:G.white60, marginBottom:24, lineHeight:1.5 }}>
          we've sent a code to<br/>
          <span style={{ color:G.white, fontWeight:700 }}>aaryan@example.com</span>
        </p>

        {/* 4 digit boxes */}
        <div style={{ display:"flex", gap:12, marginBottom:16 }}>
          {digits.map((d,i)=>(
            <div key={i} style={{
              flex:1, height:56,
              background: d ? G.surface : G.surface,
              border:`2px solid ${d?G.green:G.border}`,
              borderRadius:14,
              display:"flex", alignItems:"center", justifyContent:"center",
              fontSize:26, fontWeight:900, color:G.white,
              transition:"border-color 0.2s",
              boxShadow: d?`0 0 12px ${G.green}44`:"none",
            }}>{d}</div>
          ))}
        </div>

        <p style={{ fontSize:12, color:G.white30, marginBottom:20 }}>
          Didn't get a code?{" "}
          <span style={{ color:G.green, fontWeight:800, cursor:"pointer" }}>Click to resend.</span>
        </p>

        {/* CTA */}
        <GreenBtn label="Continue Verification" onClick={()=>{ setLoading(true); setTimeout(()=>{ setLoading(false); onNavigate("home"); },1200); }} loading={loading} disabled={digits.filter(d=>d!=="").length<4}/>
      </div>

      {/* Custom Numpad */}
      <div style={{ padding:"16px 16px 24px", background:G.black2 }}>
        {numpad.map((row,ri)=>(
          <div key={ri} style={{ display:"flex", gap:1, marginBottom:1 }}>
            {row.map((key,ki)=>(
              <div key={ki} onClick={()=>key&&handleNum(key)} style={{
                flex:1, height:56,
                background: key ? G.surface : "transparent",
                borderRadius:12,
                display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center",
                cursor:key?"pointer":"default",
                userSelect:"none",
                transition:"background 0.1s",
                margin:3,
              }}>
                {key==="del" ? (
                  <span style={{ fontSize:18, color:G.white }}>⌫</span>
                ) : key ? (
                  <>
                    <span style={{ fontSize:22, fontWeight:600, color:G.white, lineHeight:1 }}>{key}</span>
                    <span style={{ fontSize:8, color:G.white30, letterSpacing:"0.1em", marginTop:1 }}>
                      {{"2":"ABC","3":"DEF","4":"GHI","5":"JKL","6":"MNO","7":"PQRS","8":"TUV","9":"WXYZ","0":"DEF"}[key]||""}
                    </span>
                  </>
                ) : null}
              </div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// ONBOARDING — "How will you use EDUING?"
// ══════════════════════════════════════════════════════════════
function OnboardingScreen({ onNavigate }) {
  const [selected, setSelected] = useState([]);
  const options = [
    { icon:"🏛", label:"Find universities",  color:"#3DFF54" },
    { icon:"📋", label:"Track applications", color:"#FF6B35" },
    { icon:"🎓", label:"Get scholarships",   color:"#FF3B7A" },
    { icon:"📝", label:"Write SOPs",         color:"#3B5BFF" },
    { icon:"🎤", label:"Interview prep",     color:"#F5A623" },
    { icon:"📄", label:"Manage documents",   color:"#34C759" },
    { icon:"🔮", label:"AI guidance",        color:"#C084FC" },
    { icon:"📅", label:"Plan deadlines",     color:"#FF6B35" },
  ];

  const toggle = (i) => {
    setSelected(prev => prev.includes(i) ? prev.filter(x=>x!==i) : [...prev,i]);
  };

  return (
    <div style={{ height:"100%", background:G.black, display:"flex", flexDirection:"column", padding:"0 22px 28px" }}>
      <div style={{ paddingTop:6, marginBottom:16 }}>
        <div style={{ height:3, background:G.surface, borderRadius:2, marginBottom:24 }}>
          <div style={{ height:"100%", width:"100%", background:G.green, borderRadius:2 }}/>
        </div>
        <h1 style={{ fontSize:30, fontWeight:900, color:G.white, letterSpacing:"-0.8px", lineHeight:1.15, marginBottom:6 }}>
          How will you<br/>use <span style={{ color:G.green }}>EDUING?</span>
        </h1>
        <p style={{ fontSize:13, color:G.white60 }}>Select all that apply.</p>
      </div>

      <div style={{ flex:1, display:"flex", flexWrap:"wrap", gap:10, alignContent:"flex-start", overflowY:"auto" }}>
        {options.map((o,i)=>{
          const on = selected.includes(i);
          return (
            <div key={i} onClick={()=>toggle(i)} style={{
              display:"flex", alignItems:"center", gap:8,
              height:44, paddingLeft:14, paddingRight:16,
              borderRadius:22,
              background: on ? o.color+"22" : G.surface,
              border:`1.5px solid ${on?o.color:G.border}`,
              cursor:"pointer", transition:"all 0.2s",
              boxShadow: on?`0 4px 16px ${o.color}33`:"none",
            }}>
              <span style={{ fontSize:16 }}>{o.icon}</span>
              <span style={{ fontSize:13, fontWeight:700, color:on?o.color:G.white60, whiteSpace:"nowrap" }}>{o.label}</span>
            </div>
          );
        })}
      </div>

      <div style={{ marginTop:16 }}>
        <GreenBtn label={`Continue to home →`} onClick={()=>onNavigate("home")} disabled={selected.length===0}/>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// ROOT
// ══════════════════════════════════════════════════════════════
export default function App() {
  const [screen, setScreen] = useState("splash");

  const screens = {
    splash:     <SplashScreen onNavigate={setScreen}/>,
    login:      <LoginScreen onNavigate={setScreen}/>,
    register:   <RegisterScreen onNavigate={setScreen}/>,
    otp:        <OTPScreen onNavigate={setScreen}/>,
    onboarding: <OnboardingScreen onNavigate={setScreen}/>,
  };

  const labels = {
    splash:"Splash", login:"Login", register:"Register", otp:"OTP", onboarding:"Onboarding"
  };

  return (
    <div style={{
      minHeight:"100vh", background:"#050505",
      display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center",
      padding:40, gap:28,
      fontFamily:"'SF Pro Display',-apple-system,BlinkMacSystemFont,sans-serif",
    }}>
      <style>{`
        *{box-sizing:border-box;margin:0;padding:0;}
        input{font-family:inherit;}
        input::placeholder{color:rgba(255,255,255,0.2);}
        ::-webkit-scrollbar{width:0;}
        @keyframes spin{to{transform:rotate(360deg)}}
      `}</style>

      {/* Nav pills */}
      <div style={{ display:"flex", gap:6, background:"rgba(255,255,255,0.04)", padding:"6px", borderRadius:30, border:"1px solid rgba(255,255,255,0.06)" }}>
        {Object.keys(screens).map(s=>(
          <button key={s} onClick={()=>setScreen(s)} style={{
            padding:"7px 16px", borderRadius:20, border:"none",
            background: screen===s ? G.green : "transparent",
            color: screen===s ? G.black : "rgba(255,255,255,0.35)",
            fontWeight:800, cursor:"pointer", fontSize:12,
            transition:"all 0.2s", fontFamily:"inherit",
            letterSpacing:"0.02em",
          }}>{labels[s]}</button>
        ))}
      </div>

      <Phone label={labels[screen]}>
        {screens[screen]}
      </Phone>
    </div>
  );
}

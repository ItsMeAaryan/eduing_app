import { useState, useEffect, useRef } from "react";

// ── DESIGN TOKENS ──────────────────────────────────────────────
const C = {
  bg:        "#05060F",
  bg2:       "#0B0D1A",
  surface:   "rgba(255,255,255,0.05)",
  surfaceHover: "rgba(255,255,255,0.08)",
  border:    "rgba(255,255,255,0.08)",
  borderFocus:"rgba(124,58,237,0.8)",
  blue1:     "#1A1AFF",
  blue2:     "#3B5BFF",
  purple:    "#7C3AED",
  purple2:   "#9F6FFF",
  violet:    "#C084FC",
  glow:      "rgba(124,58,237,0.35)",
  glow2:     "rgba(59,91,255,0.25)",
  text:      "#FFFFFF",
  textSub:   "rgba(255,255,255,0.5)",
  textMuted: "rgba(255,255,255,0.28)",
  error:     "#FF5C5C",
  success:   "#34D399",
};

const gradientBg = `radial-gradient(ellipse 80% 60% at 50% -20%, rgba(124,58,237,0.4) 0%, transparent 70%),
  radial-gradient(ellipse 60% 40% at 80% 80%, rgba(59,91,255,0.2) 0%, transparent 60%),
  radial-gradient(ellipse 40% 30% at 10% 60%, rgba(192,132,252,0.15) 0%, transparent 50%),
  linear-gradient(180deg, #05060F 0%, #08091A 100%)`;

// ── FLOATING ORBS ──────────────────────────────────────────────
function Orbs() {
  return (
    <div style={{ position:"absolute", inset:0, overflow:"hidden", pointerEvents:"none" }}>
      {[
        { w:200, h:200, x:"60%", y:"-5%", c:"rgba(124,58,237,0.18)", blur:60, anim:"orb1" },
        { w:160, h:160, x:"-10%", y:"30%", c:"rgba(59,91,255,0.15)", blur:50, anim:"orb2" },
        { w:120, h:120, x:"70%", y:"55%", c:"rgba(192,132,252,0.12)", blur:40, anim:"orb3" },
      ].map((o,i) => (
        <div key={i} style={{
          position:"absolute", width:o.w, height:o.h,
          left:o.x, top:o.y,
          background:`radial-gradient(circle, ${o.c} 0%, transparent 70%)`,
          filter:`blur(${o.blur}px)`,
          animation:`${o.anim} 8s ease-in-out infinite`,
          animationDelay:`${i*2}s`,
        }}/>
      ))}
    </div>
  );
}

// ── GLASS CARD ─────────────────────────────────────────────────
function GlassCard({ children, style={}, glow=false }) {
  return (
    <div style={{
      background: "rgba(255,255,255,0.04)",
      backdropFilter: "blur(20px)",
      WebkitBackdropFilter: "blur(20px)",
      border: `1px solid ${glow ? "rgba(124,58,237,0.4)" : "rgba(255,255,255,0.07)"}`,
      borderRadius: 20,
      boxShadow: glow
        ? "0 0 40px rgba(124,58,237,0.2), inset 0 1px 0 rgba(255,255,255,0.1)"
        : "0 8px 32px rgba(0,0,0,0.3), inset 0 1px 0 rgba(255,255,255,0.06)",
      ...style,
    }}>
      {children}
    </div>
  );
}

// ── GLOWING INPUT ──────────────────────────────────────────────
function GlowInput({ label, type="text", placeholder, value, onChange, error, rightEl }) {
  const [focused, setFocused] = useState(false);
  return (
    <div style={{ marginBottom:16 }}>
      {label && <label style={{ fontSize:11, fontWeight:700, color:C.textMuted, marginBottom:8, display:"block", letterSpacing:"0.08em", textTransform:"uppercase" }}>{label}</label>}
      <div style={{ position:"relative" }}>
        <input
          type={type} placeholder={placeholder} value={value}
          onChange={onChange}
          onFocus={()=>setFocused(true)} onBlur={()=>setFocused(false)}
          style={{
            width:"100%", height:52,
            background: focused ? "rgba(124,58,237,0.08)" : "rgba(255,255,255,0.04)",
            border:`1.5px solid ${error ? C.error : focused ? C.purple2 : C.border}`,
            borderRadius:14,
            padding: rightEl ? "0 48px 0 16px" : "0 16px",
            fontSize:15, color:C.text, outline:"none",
            boxSizing:"border-box", fontFamily:"inherit",
            transition:"all 0.25s",
            boxShadow: focused ? `0 0 0 3px rgba(124,58,237,0.15), 0 0 20px rgba(124,58,237,0.1)` : "none",
          }}
        />
        {rightEl && (
          <div style={{ position:"absolute", right:14, top:"50%", transform:"translateY(-50%)", cursor:"pointer", color:C.textSub }}>{rightEl}</div>
        )}
      </div>
      {error && <p style={{ fontSize:12, color:C.error, marginTop:5 }}>{error}</p>}
    </div>
  );
}

// ── GLOW BUTTON ────────────────────────────────────────────────
function GlowBtn({ label, onClick, disabled, loading, variant="primary" }) {
  const [pressed, setPressed] = useState(false);
  const isPrimary = variant === "primary";
  return (
    <button
      onClick={onClick} disabled={disabled || loading}
      onMouseDown={()=>setPressed(true)} onMouseUp={()=>setPressed(false)}
      style={{
        width:"100%", height:56, border:"none", borderRadius:28,
        fontSize:16, fontWeight:700, cursor: disabled ? "not-allowed" : "pointer",
        letterSpacing:"0.02em", fontFamily:"inherit",
        transform: pressed ? "scale(0.97)" : "scale(1)",
        transition:"all 0.15s",
        opacity: disabled ? 0.4 : 1,
        position:"relative", overflow:"hidden",
        ...(isPrimary ? {
          background: `linear-gradient(135deg, ${C.purple} 0%, ${C.blue2} 100%)`,
          color:"#fff",
          boxShadow: disabled ? "none" : `0 4px 24px rgba(124,58,237,0.5), 0 0 0 1px rgba(255,255,255,0.1) inset`,
        } : {
          background: "rgba(255,255,255,0.05)",
          color: C.text,
          border: `1px solid ${C.border}`,
          boxShadow: "none",
        }),
      }}
    >
      {/* Shimmer overlay */}
      {isPrimary && !disabled && (
        <div style={{
          position:"absolute", inset:0,
          background:"linear-gradient(105deg, transparent 40%, rgba(255,255,255,0.15) 50%, transparent 60%)",
          animation:"shimmer 3s ease-in-out infinite",
        }}/>
      )}
      <span style={{ position:"relative", zIndex:1, display:"flex", alignItems:"center", justifyContent:"center", gap:8 }}>
        {loading ? <span style={{ animation:"spin 1s linear infinite", display:"inline-block", fontSize:18 }}>⟳</span> : label}
      </span>
    </button>
  );
}

// ── GOOGLE BUTTON ──────────────────────────────────────────────
function GoogleBtn() {
  const [hov, setHov] = useState(false);
  return (
    <button
      onMouseEnter={()=>setHov(true)} onMouseLeave={()=>setHov(false)}
      style={{
        width:"100%", height:50,
        background: hov ? "rgba(255,255,255,0.08)" : "rgba(255,255,255,0.05)",
        border:`1px solid ${hov ? "rgba(255,255,255,0.15)" : C.border}`,
        borderRadius:25, fontSize:14, fontWeight:600, color:C.text,
        cursor:"pointer", display:"flex", alignItems:"center", justifyContent:"center",
        gap:10, fontFamily:"inherit", transition:"all 0.2s",
        boxShadow: hov ? "0 4px 20px rgba(0,0,0,0.3)" : "none",
      }}
    >
      <svg width="18" height="18" viewBox="0 0 24 24">
        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
      </svg>
      Continue with Google
    </button>
  );
}

function Divider() {
  return (
    <div style={{ display:"flex", alignItems:"center", gap:12, margin:"18px 0" }}>
      <div style={{ flex:1, height:1, background:C.border }}/>
      <span style={{ fontSize:12, color:C.textMuted, fontWeight:600, letterSpacing:"0.05em" }}>OR</span>
      <div style={{ flex:1, height:1, background:C.border }}/>
    </div>
  );
}

// ── LOGO MARK ──────────────────────────────────────────────────
function LogoMark({ size=48 }) {
  return (
    <div style={{
      width:size, height:size, borderRadius:size*0.3,
      background:`linear-gradient(135deg, ${C.purple} 0%, ${C.blue2} 100%)`,
      display:"flex", alignItems:"center", justifyContent:"center",
      boxShadow:`0 8px 24px rgba(124,58,237,0.5), 0 0 0 1px rgba(255,255,255,0.15) inset`,
      fontSize:size*0.45,
    }}>🎓</div>
  );
}

// ── SPLASH SCREEN ──────────────────────────────────────────────
function SplashScreen({ onNavigate }) {
  const [idx, setIdx] = useState(0);
  const [animating, setAnimating] = useState(false);

  const slides = [
    {
      icon:"🎓",
      badge:"INDIA'S #1 ADMISSION PLATFORM",
      title:"One app.\nEvery admission.",
      sub:"From JEE to Oxford — search, apply, and track your entire admission journey.",
      accent: C.purple,
    },
    {
      icon:"🤖",
      badge:"AI-POWERED",
      title:"Your AI\nstrategist.",
      sub:"Drafts SOPs, predicts cutoffs, checks documents, and coaches you for interviews.",
      accent: C.blue2,
    },
    {
      icon:"🔐",
      badge:"BANK-GRADE SECURITY",
      title:"Your vault.\nYour docs.",
      sub:"Encrypted document storage with AI verification and instant sharing.",
      accent: C.violet,
    },
  ];

  const next = () => {
    if (animating) return;
    if (idx < slides.length - 1) { setAnimating(true); setTimeout(()=>{ setIdx(i=>i+1); setAnimating(false); }, 200); }
  };

  const s = slides[idx];

  return (
    <div style={{ flex:1, display:"flex", flexDirection:"column", padding:"0 28px 48px", position:"relative" }}>
      <Orbs/>

      {/* Skip */}
      <div style={{ display:"flex", justifyContent:"flex-end", paddingTop:8, position:"relative", zIndex:1 }}>
        <span onClick={()=>onNavigate("login")} style={{ fontSize:13, color:C.textMuted, fontWeight:600, cursor:"pointer", letterSpacing:"0.03em" }}>Skip</span>
      </div>

      {/* 3D Float Card */}
      <div style={{ flex:1, display:"flex", alignItems:"center", justifyContent:"center", position:"relative", zIndex:1 }}>
        <div style={{
          width:200, height:200,
          background:`radial-gradient(ellipse at 30% 30%, ${s.accent}33 0%, ${s.accent}11 50%, transparent 80%)`,
          border:`1px solid ${s.accent}33`,
          borderRadius:48,
          display:"flex", alignItems:"center", justifyContent:"center",
          fontSize:80,
          boxShadow:`0 32px 80px ${s.accent}33, 0 0 0 1px ${s.accent}22 inset`,
          animation:"float 4s ease-in-out infinite",
          backdropFilter:"blur(10px)",
          opacity: animating ? 0 : 1,
          transform: animating ? "scale(0.9)" : "scale(1)",
          transition:"opacity 0.2s, transform 0.2s",
        }}>
          {s.icon}
          {/* Shine */}
          <div style={{
            position:"absolute", top:12, left:12, width:60, height:30,
            background:"rgba(255,255,255,0.08)", borderRadius:30, filter:"blur(8px)",
            transform:"rotate(-20deg)",
          }}/>
        </div>

        {/* Floating dots */}
        {[{x:-40,y:-30,size:8},{x:60,y:-50,size:5},{x:80,y:40,size:6},{x:-60,y:50,size:4}].map((d,i)=>(
          <div key={i} style={{
            position:"absolute", left:`calc(50% + ${d.x}px)`, top:`calc(50% + ${d.y}px)`,
            width:d.size, height:d.size, borderRadius:"50%",
            background:s.accent, opacity:0.4,
            animation:`float 3s ease-in-out infinite`,
            animationDelay:`${i*0.5}s`,
          }}/>
        ))}
      </div>

      {/* Content */}
      <div style={{ position:"relative", zIndex:1 }}>
        {/* Badge */}
        <div style={{
          display:"inline-flex", alignItems:"center", gap:6,
          background:`${s.accent}22`, border:`1px solid ${s.accent}44`,
          borderRadius:20, padding:"4px 12px", marginBottom:16,
        }}>
          <div style={{ width:6, height:6, borderRadius:3, background:s.accent, boxShadow:`0 0 6px ${s.accent}` }}/>
          <span style={{ fontSize:10, fontWeight:800, color:s.accent, letterSpacing:"0.1em" }}>{s.badge}</span>
        </div>

        <h1 style={{
          fontSize:34, fontWeight:900, color:C.text, margin:"0 0 14px",
          letterSpacing:"-0.8px", lineHeight:1.15,
          whiteSpace:"pre-line",
          opacity: animating ? 0 : 1, transition:"opacity 0.2s",
        }}>{s.title}</h1>
        <p style={{ fontSize:15, color:C.textSub, lineHeight:1.65, marginBottom:32, opacity: animating ? 0 : 1, transition:"opacity 0.2s 0.05s" }}>
          {s.sub}
        </p>

        {/* Dots */}
        <div style={{ display:"flex", gap:8, marginBottom:28 }}>
          {slides.map((_,i)=>(
            <div key={i} onClick={()=>setIdx(i)} style={{
              height:4, borderRadius:2,
              width: i===idx ? 28 : 6,
              background: i===idx ? s.accent : C.border,
              cursor:"pointer", transition:"all 0.3s",
              boxShadow: i===idx ? `0 0 8px ${s.accent}88` : "none",
            }}/>
          ))}
        </div>

        {idx < slides.length-1 ? (
          <GlowBtn label="Next →" onClick={next}/>
        ) : (
          <div style={{ display:"flex", flexDirection:"column", gap:10 }}>
            <GlowBtn label="Get started" onClick={()=>onNavigate("register")}/>
            <GlowBtn label="I have an account" onClick={()=>onNavigate("login")} variant="ghost"/>
          </div>
        )}
      </div>
    </div>
  );
}

// ── LOGIN SCREEN ───────────────────────────────────────────────
function LoginScreen({ onNavigate }) {
  const [email, setEmail] = useState("");
  const [pass, setPass] = useState("");
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);

  return (
    <div style={{ flex:1, padding:"0 28px 36px", overflowY:"auto", display:"flex", flexDirection:"column", position:"relative" }}>
      <Orbs/>
      <div style={{ position:"relative", zIndex:1, flex:1, display:"flex", flexDirection:"column" }}>

        <div style={{ paddingTop:12, marginBottom:36 }}>
          <LogoMark size={48}/>
          <h1 style={{ fontSize:30, fontWeight:900, color:C.text, margin:"20px 0 6px", letterSpacing:"-0.5px" }}>Welcome back.</h1>
          <p style={{ fontSize:14, color:C.textSub, margin:0 }}>Sign in to continue your admission journey.</p>
        </div>

        <GoogleBtn/>
        <Divider/>

        <GlowInput label="Email address" type="email" placeholder="you@example.com" value={email} onChange={e=>setEmail(e.target.value)}/>
        <GlowInput label="Password" type={showPass?"text":"password"} placeholder="••••••••" value={pass} onChange={e=>setPass(e.target.value)}
          rightEl={<span onClick={()=>setShowPass(!showPass)} style={{fontSize:15}}>{showPass?"🙈":"👁"}</span>}
        />

        <div style={{ textAlign:"right", marginTop:-8, marginBottom:24 }}>
          <span onClick={()=>onNavigate("forgot")} style={{ fontSize:13, fontWeight:600, color:C.purple2, cursor:"pointer" }}>Forgot password?</span>
        </div>

        <GlowBtn label="Sign in" onClick={()=>{ setLoading(true); setTimeout(()=>setLoading(false),1500); }} loading={loading} disabled={!email||!pass}/>

        {/* Biometric */}
        <div style={{ display:"flex", flexDirection:"column", alignItems:"center", marginTop:28, gap:8 }}>
          <GlassCard style={{ width:56, height:56, display:"flex", alignItems:"center", justifyContent:"center", cursor:"pointer", fontSize:22, borderRadius:28 }}>
            👆
          </GlassCard>
          <span style={{ fontSize:12, color:C.textMuted }}>Biometric login</span>
        </div>

        <p style={{ textAlign:"center", fontSize:14, color:C.textSub, marginTop:"auto", paddingTop:24 }}>
          No account?{" "}
          <span onClick={()=>onNavigate("register")} style={{ color:C.purple2, fontWeight:700, cursor:"pointer" }}>Create one</span>
        </p>
      </div>
    </div>
  );
}

// ── REGISTER SCREEN ────────────────────────────────────────────
function RegisterScreen({ onNavigate }) {
  const [step, setStep] = useState(1);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [pass, setPass] = useState("");
  const [confirm, setConfirm] = useState("");
  const [loading, setLoading] = useState(false);

  const strength = pass.length===0?0:pass.length<6?1:pass.length<10?2:3;
  const sColor = [C.border, C.error, "#F59E0B", C.success][strength];
  const sLabel = ["","Weak","Fair","Strong"][strength];

  return (
    <div style={{ flex:1, padding:"0 28px 36px", overflowY:"auto", display:"flex", flexDirection:"column", position:"relative" }}>
      <Orbs/>
      <div style={{ position:"relative", zIndex:1, flex:1, display:"flex", flexDirection:"column" }}>

        {/* Header */}
        <div style={{ display:"flex", alignItems:"center", gap:12, paddingTop:8, marginBottom:28 }}>
          <button onClick={()=>step===1?onNavigate("login"):setStep(1)} style={{
            width:40, height:40, borderRadius:20, background:"rgba(255,255,255,0.05)",
            border:`1px solid ${C.border}`, display:"flex", alignItems:"center", justifyContent:"center",
            cursor:"pointer", fontSize:16, color:C.text,
          }}>←</button>
          <div style={{ flex:1, display:"flex", gap:6 }}>
            {[1,2].map(s=>(
              <div key={s} style={{ flex:1, height:3, borderRadius:2,
                background: s<=step ? `linear-gradient(90deg, ${C.purple}, ${C.blue2})` : C.border,
                boxShadow: s<=step ? `0 0 8px ${C.purple}88` : "none",
                transition:"all 0.3s" }}/>
            ))}
          </div>
          <span style={{ fontSize:12, color:C.textMuted, fontWeight:700 }}>{step}/2</span>
        </div>

        <div style={{ marginBottom:28 }}>
          <h1 style={{ fontSize:28, fontWeight:900, color:C.text, margin:"0 0 6px", letterSpacing:"-0.5px" }}>
            {step===1?"Create account.":"Set password."}
          </h1>
          <p style={{ fontSize:14, color:C.textSub, margin:0 }}>
            {step===1?"Start your admission journey today.":"Make it strong and unique."}
          </p>
        </div>

        {step===1 ? (
          <>
            <GoogleBtn/>
            <Divider/>
            <GlowInput label="Full name" placeholder="Aaryan Sharma" value={name} onChange={e=>setName(e.target.value)}/>
            <GlowInput label="Email address" type="email" placeholder="you@example.com" value={email} onChange={e=>setEmail(e.target.value)}/>
            <GlowInput label="Phone number" type="tel" placeholder="+91 98765 43210" value={phone} onChange={e=>setPhone(e.target.value)}/>
          </>
        ) : (
          <>
            <GlowInput label="Password" type="password" placeholder="Min. 8 characters" value={pass} onChange={e=>setPass(e.target.value)}/>
            {pass.length>0 && (
              <div style={{ marginTop:-8, marginBottom:16 }}>
                <div style={{ display:"flex", gap:4, marginBottom:6 }}>
                  {[1,2,3].map(i=>(
                    <div key={i} style={{ flex:1, height:3, borderRadius:2,
                      background: i<=strength ? sColor : C.border,
                      boxShadow: i<=strength ? `0 0 6px ${sColor}` : "none",
                      transition:"all 0.3s" }}/>
                  ))}
                </div>
                <span style={{ fontSize:11, color:sColor, fontWeight:700, letterSpacing:"0.05em" }}>{sLabel}</span>
              </div>
            )}
            <GlowInput label="Confirm password" type="password" placeholder="Repeat password" value={confirm} onChange={e=>setConfirm(e.target.value)}
              error={confirm&&pass!==confirm?"Passwords don't match":""}
            />
            <p style={{ fontSize:12, color:C.textMuted, lineHeight:1.6, marginBottom:20 }}>
              By continuing you agree to our{" "}
              <span style={{ color:C.purple2 }}>Terms</span> and <span style={{ color:C.purple2 }}>Privacy Policy</span>.
            </p>
          </>
        )}

        <div style={{ marginTop:"auto" }}>
          <GlowBtn
            label={step===1?"Continue →":"Create account"}
            onClick={()=>{ if(step===1)setStep(2); else{ setLoading(true); setTimeout(()=>setLoading(false),1500); } }}
            loading={loading}
            disabled={step===2&&(pass!==confirm||pass.length<8)}
          />
          <p style={{ textAlign:"center", fontSize:13, color:C.textSub, marginTop:18 }}>
            Have an account?{" "}
            <span onClick={()=>onNavigate("login")} style={{ color:C.purple2, fontWeight:700, cursor:"pointer" }}>Sign in</span>
          </p>
        </div>
      </div>
    </div>
  );
}

// ── FORGOT PASSWORD ────────────────────────────────────────────
function ForgotScreen({ onNavigate }) {
  const [step, setStep] = useState(1);
  const [email, setEmail] = useState("");
  const [otp, setOtp] = useState(["","","","","",""]);
  const [newPass, setNewPass] = useState("");
  const [loading, setLoading] = useState(false);
  const [timer, setTimer] = useState(30);

  useEffect(()=>{
    if(step!==2) return;
    setTimer(30);
    const t = setInterval(()=>setTimer(v=>v>0?v-1:0),1000);
    return ()=>clearInterval(t);
  },[step]);

  const handleOtp = (val,idx) => {
    const next=[...otp]; next[idx]=val.slice(-1); setOtp(next);
  };

  const steps = [
    { icon:"🔐", badge:"STEP 1", title:"Forgot password?", sub:"Enter your registered email address." },
    { icon:"📩", badge:"STEP 2", title:"Check your email.", sub:`Code sent to ${email||"your email"}.` },
    { icon:"🔑", badge:"STEP 3", title:"New password.", sub:"Choose something strong." },
  ];
  const s = steps[step-1];

  return (
    <div style={{ flex:1, padding:"0 28px 36px", display:"flex", flexDirection:"column", position:"relative" }}>
      <Orbs/>
      <div style={{ position:"relative", zIndex:1, flex:1, display:"flex", flexDirection:"column" }}>

        <div style={{ display:"flex", alignItems:"center", gap:12, paddingTop:8, marginBottom:28 }}>
          <button onClick={()=>step===1?onNavigate("login"):setStep(s=>s-1)} style={{
            width:40,height:40,borderRadius:20,background:"rgba(255,255,255,0.05)",
            border:`1px solid ${C.border}`,display:"flex",alignItems:"center",justifyContent:"center",
            cursor:"pointer",fontSize:16,color:C.text,
          }}>←</button>
          <div style={{ flex:1, display:"flex", gap:6 }}>
            {[1,2,3].map(i=>(
              <div key={i} style={{ flex:1, height:3, borderRadius:2,
                background: i<=step?`linear-gradient(90deg,${C.purple},${C.blue2})`:C.border,
                boxShadow: i<=step?`0 0 8px ${C.purple}88`:"none", transition:"all 0.3s" }}/>
            ))}
          </div>
        </div>

        {/* Icon */}
        <GlassCard style={{ width:60, height:60, display:"flex", alignItems:"center", justifyContent:"center", fontSize:28, marginBottom:20, borderRadius:20 }} glow>
          {s.icon}
        </GlassCard>

        <div style={{ display:"inline-flex", alignItems:"center", gap:6, marginBottom:12,
          background:"rgba(124,58,237,0.12)", border:"1px solid rgba(124,58,237,0.3)", borderRadius:20, padding:"3px 10px", width:"fit-content" }}>
          <span style={{ fontSize:10, fontWeight:800, color:C.purple2, letterSpacing:"0.08em" }}>{s.badge}</span>
        </div>

        <h1 style={{ fontSize:26, fontWeight:900, color:C.text, margin:"0 0 8px", letterSpacing:"-0.5px" }}>{s.title}</h1>
        <p style={{ fontSize:14, color:C.textSub, marginBottom:28, lineHeight:1.55 }}>{s.sub}</p>

        {step===1 && <GlowInput label="Email address" type="email" placeholder="you@example.com" value={email} onChange={e=>setEmail(e.target.value)}/>}

        {step===2 && (
          <>
            <div style={{ display:"flex", gap:8, marginBottom:24, justifyContent:"center" }}>
              {otp.map((v,i)=>(
                <input key={i} value={v} onChange={e=>handleOtp(e.target.value,i)} maxLength={1}
                  style={{
                    width:42,height:50,textAlign:"center",fontSize:20,fontWeight:700,
                    background: v?"rgba(124,58,237,0.15)":"rgba(255,255,255,0.04)",
                    border:`1.5px solid ${v?C.purple2:C.border}`,
                    borderRadius:12,color:C.text,outline:"none",fontFamily:"inherit",
                    boxShadow: v?`0 0 12px rgba(124,58,237,0.3)`:"none",
                    transition:"all 0.2s",
                  }}/>
              ))}
            </div>
            <p style={{ textAlign:"center", fontSize:13, color:C.textMuted, marginBottom:24 }}>
              {timer>0 ? `Resend in ${timer}s` : <span style={{ color:C.purple2, cursor:"pointer", fontWeight:700 }} onClick={()=>setTimer(30)}>Resend code</span>}
            </p>
          </>
        )}

        {step===3 && <GlowInput label="New password" type="password" placeholder="Min. 8 characters" value={newPass} onChange={e=>setNewPass(e.target.value)}/>}

        <div style={{ marginTop:"auto" }}>
          <GlowBtn
            label={step===1?"Send code":step===2?"Verify →":"Reset password"}
            onClick={()=>{
              setLoading(true);
              setTimeout(()=>{ setLoading(false); if(step<3)setStep(s=>s+1); else onNavigate("login"); },1200);
            }}
            loading={loading}
            disabled={(step===1&&!email)||(step===2&&otp.join("").length<6)||(step===3&&newPass.length<8)}
          />
        </div>
      </div>
    </div>
  );
}

// ── PHONE FRAME ────────────────────────────────────────────────
function PhoneFrame({ children }) {
  return (
    <div style={{
      width:375, minHeight:812,
      background:C.bg,
      backgroundImage:gradientBg,
      borderRadius:50,
      overflow:"hidden",
      boxShadow:"0 60px 120px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,255,255,0.08), inset 0 1px 0 rgba(255,255,255,0.12)",
      position:"relative",
      display:"flex", flexDirection:"column",
      border:"8px solid #111",
    }}>
      {/* Notch */}
      <div style={{ height:44, display:"flex", alignItems:"center", justifyContent:"space-between", padding:"0 24px", flexShrink:0, zIndex:10, position:"relative" }}>
        <span style={{ fontSize:13, fontWeight:700, color:C.text }}>9:41</span>
        <div style={{
          position:"absolute", left:"50%", transform:"translateX(-50%)",
          width:120, height:34, background:"#000", borderRadius:"0 0 20px 20px",
          top:0,
        }}/>
        <div style={{ display:"flex", gap:5, alignItems:"center" }}>
          {[0.5,0.7,1].map((o,i)=><div key={i} style={{ width:3+i, height:7+i*2, background:C.text, borderRadius:1, opacity:o }}/>)}
          <div style={{ width:15, height:7, border:`1.5px solid ${C.text}`, borderRadius:3, marginLeft:4, position:"relative" }}>
            <div style={{ position:"absolute", left:1, top:1, right:2, bottom:1, background:C.text, borderRadius:1 }}/>
          </div>
        </div>
      </div>
      <div style={{ flex:1, display:"flex", flexDirection:"column", overflow:"hidden" }}>
        {children}
      </div>
    </div>
  );
}

// ── ROOT ───────────────────────────────────────────────────────
export default function App() {
  const [screen, setScreen] = useState("splash");

  const map = {
    splash:   <SplashScreen onNavigate={setScreen}/>,
    login:    <LoginScreen onNavigate={setScreen}/>,
    register: <RegisterScreen onNavigate={setScreen}/>,
    forgot:   <ForgotScreen onNavigate={setScreen}/>,
  };

  return (
    <div style={{
      minHeight:"100vh", background:"#030408",
      display:"flex", alignItems:"center", justifyContent:"center",
      padding:40, fontFamily:"-apple-system,BlinkMacSystemFont,'SF Pro Display','Segoe UI',sans-serif",
    }}>
      <style>{`
        *{box-sizing:border-box;margin:0;padding:0;}
        input{font-family:inherit;}
        input::placeholder{color:rgba(255,255,255,0.2);}
        ::-webkit-scrollbar{width:0;}
        @keyframes float{0%,100%{transform:translateY(0) rotate(0deg)}50%{transform:translateY(-12px) rotate(1deg)}}
        @keyframes shimmer{0%{transform:translateX(-100%)}100%{transform:translateX(200%)}}
        @keyframes spin{to{transform:rotate(360deg)}}
        @keyframes orb1{0%,100%{transform:translate(0,0)}50%{transform:translate(-20px,15px)}}
        @keyframes orb2{0%,100%{transform:translate(0,0)}50%{transform:translate(15px,-20px)}}
        @keyframes orb3{0%,100%{transform:translate(0,0)}50%{transform:translate(-10px,10px)}}
      `}</style>

      <PhoneFrame>{map[screen]}</PhoneFrame>

      {/* Nav pills */}
      <div style={{ position:"fixed", bottom:24, left:"50%", transform:"translateX(-50%)", display:"flex", gap:8, zIndex:100, background:"rgba(0,0,0,0.6)", backdropFilter:"blur(12px)", padding:"8px 12px", borderRadius:30, border:"1px solid rgba(255,255,255,0.08)" }}>
        {["splash","login","register","forgot"].map(s=>(
          <button key={s} onClick={()=>setScreen(s)} style={{
            padding:"6px 14px", borderRadius:16,
            background: screen===s?`linear-gradient(135deg,${C.purple},${C.blue2})`:"transparent",
            color: screen===s?"#fff":"rgba(255,255,255,0.4)",
            border:"none", fontWeight:700, cursor:"pointer", fontSize:12,
            boxShadow: screen===s?`0 4px 12px ${C.purple}66`:"none",
            transition:"all 0.2s",
          }}>{s}</button>
        ))}
      </div>
    </div>
  );
}

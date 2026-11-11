/*
  src/parts/paper-kit.js — 부품이 같이 쓰는 도우미 두 가지 (직접 만든 모양, 레퍼런스 이미지를 쓰지 않음)
  1) Kit.torn  : 찢은 종이 가장자리 (clip-path, 꼭짓점은 시계 방향). data-torn="top bottom" 처럼 찢을 변을 적은 요소에 자동으로 붙는다.
                 data-torn-amp(들쭉날쭉 깊이 px, 기본 8) · data-torn-step(톱니 간격 px, 기본 12) · data-seed(모양 번호)
  2) Kit.ring  : 빨간 손그림 동그라미. 1주차 영상(1주차 프로젝트 shared/parts.js NT.ringPath)과 같은 모양.
                 글자 상자보다 좌우 26px + 너비의 3%, 위아래 14px + 높이의 25% 여유 (design.md 7장)
  같은 seed면 언제 그려도 같은 모양이 나온다 (렌더할 때마다 흔들리지 않음).
*/
(function () {
  function rng(seed) {
    let s = (seed >>> 0) || 1;
    return function () { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296; };
  }

  // pts: 꼭짓점 [[x,y],...], torn: 변마다 찢을지 [true,false,...]
  function tornPoints(pts, torn, opt) {
    const r = rng(opt.seed || 7), amp = opt.amp || 8, step = opt.step || 12, out = [];
    for (let i = 0; i < pts.length; i++) {
      const a = pts[i], b = pts[(i + 1) % pts.length];
      out.push(a);
      if (!torn[i]) continue;
      const dx = b[0] - a[0], dy = b[1] - a[1], len = Math.hypot(dx, dy);
      const n = Math.max(2, Math.round(len / step)), nx = -dy / len, ny = dx / len;
      for (let k = 1; k < n; k++) {
        const t = (k + (r() - 0.5) * 0.5) / n;
        const off = r() * amp + (r() < 0.12 ? r() * amp : 0); // 안쪽으로만 파이고, 가끔 더 깊게 (꼭짓점은 시계 방향 순서)
        out.push([a[0] + dx * t + nx * off, a[1] + dy * t + ny * off]);
      }
    }
    return out;
  }
  function toPolygon(pts) {
    return "polygon(" + pts.map(function (p) { return p[0].toFixed(1) + "px " + p[1].toFixed(1) + "px"; }).join(",") + ")";
  }
  function tornPath(pts, torn, opt) { return toPolygon(tornPoints(pts, torn, opt || {})); }

  function applyTorn(root) {
    (root || document).querySelectorAll("[data-torn]").forEach(function (el) {
      const w = el.offsetWidth, h = el.offsetHeight, s = el.dataset.torn.split(/\s+/);
      const pts = [[0, 0], [w, 0], [w, h], [0, h]];
      const torn = [s.includes("top"), s.includes("right"), s.includes("bottom"), s.includes("left")];
      el.style.clipPath = tornPath(pts, torn, {
        amp: +el.dataset.tornAmp || 8, step: +el.dataset.tornStep || 12, seed: +el.dataset.seed || 7
      });
    });
  }

  // 손으로 그린 듯한 타원 (1주차 NT.ringPath와 같은 식)
  function ringPath(b, seed, padX, padY) {
    padX = padX == null ? 26 : padX;
    padY = padY == null ? 14 : padY;
    // 1주차 식(rx = w/2 + 26, ry = h/2 + 14)은 짧은 낱말용. 긴 글은 타원 양 끝이 글자 모서리를 가로질러서
    // 반지름에 너비의 3% · 높이의 25%를 더 둔다 (짧은 낱말에서는 1주차와 거의 같다)
    const rx = b.w / 2 + padX + 0.03 * b.w, ry = b.h / 2 + padY + 0.25 * b.h;
    let d = "";
    for (let i = 0; i <= 64; i++) {
      const a = (-200 + (375 * i) / 64) * Math.PI / 180;
      const k = 1 + 0.03 * Math.sin(3 * a + seed) + 0.02 * (i / 64);
      d += (i ? " L" : "M") + (b.cx + rx * k * Math.cos(a)).toFixed(1) + " " + (b.cy + ry * k * Math.sin(a)).toFixed(1);
    }
    return d;
  }
  // target 글자를 감싸는 동그라미를 layer(svg) 안 path에 그린다. 좌표는 layer 기준.
  function ring(target, path, seed) {
    const L = path.ownerSVGElement.getBoundingClientRect(), t = target.getBoundingClientRect();
    const b = { w: t.width, h: t.height, cx: t.left - L.left + t.width / 2, cy: t.top - L.top + t.height / 2 };
    path.setAttribute("d", ringPath(b, seed || 0));
  }
  function applyRings(root) {
    (root || document).querySelectorAll("[data-ring]").forEach(function (el, i) {
      const p = document.getElementById(el.dataset.ring);
      if (p) ring(el, p, i * 1.7);
    });
  }

  function applyAll() { applyTorn(); applyRings(); }
  window.Kit = { torn: applyTorn, tornPath: tornPath, tornPoints: tornPoints, ring: ring, ringPath: ringPath, rings: applyRings, apply: applyAll };
  // 글꼴이 다 읽힌 뒤에 크기를 재야 모양이 맞는다
  (document.fonts ? document.fonts.ready : Promise.resolve()).then(applyAll);
})();

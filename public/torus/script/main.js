//(function () {
//    function sendAccounting(o, t) {
//        o = o || 1;
//        t = t || 0;
//        var e = new Image;
////        e.src = "http://58.100.228.118:80/" + o + "-29182/2c335fdc-6087-46a3-9909-aad6f603e332_58.100.53.68/" + t + "." + (T + h);
//        return e
//    }
//    function o(o) {
////        return 1 == o && "http://58.100.228.118/CheckUrl/1/29182"
//    }
//    function t(t) {
//        var r, i = Math.floor(1e3 * h),
//            n = "fp",
//            s = n + i,
//            l = "5e2e7f1d059d320e3a3590b7f5f3c618cb83b2f7",
//            a = "_!$[]fp2c335fdc-6087-46a3-9909-aad6f603e332[]$!_";
//        "string" == typeof t.jsURI && (t.jsURI = [t.jsURI]);
//        if (g[a] === l) return 1;
//        g[a] = l;
//        if (t.requireTopWindow && g != top) return 2;
//        if (t.requireObjectHasOwnProperty && !Object.prototype.hasOwnProperty) return 3;
//        if (t.json) {
//                if ("string" == typeof t.json) try {
//                    t.json = g.eval("(" + t.json + ")")
//                } catch (_) {
//                    return 4
//                }
//                t.json.minimum_width = t.minWidth = t.json.minimum_width || t.minWidth;
//                t.json.minimum_height = t.minHeight = t.json.minimum_height || t.minHeight;
//                t.json._accounting = {
//                    stopTime: d,
//                    sendAccounting: sendAccounting,
////                    uri: "http://58.100.228.118/static",
//                    check: o("1")
//                }
//            }
//        if (!(t.json && "" === t.json.sprite_img || e(t.minHeight, t.minWidth))) return 5;
//        if (t.json2uri) {
//                for (; void 0 !== g[s];) s = n + ++i;
//                g[s] = t.json;
//                for (r = 0; t.jsURI.length > r; r++) t.jsURI[r] += (-1 !== t.jsURI[r].indexOf("?") ? "&" : "?") + s
//            }
//    }
//    function e(o, t) {
//        var e = C.documentElement || C.body || {},
//            r = g.innerWidth || e.clientWidth || 0,
//            i = g.innerHeight || e.clientHeight || 0;
//        return r >= o && i >= t || !(r + i)
//    }
//    function r() {
//        var o, e, r, i, l, a, _, c = (new Date).getTime(),
//            f = {
//                requireTopWindow: !0,
//                requireObjectHasOwnProperty: !0,
//                minWidth: 550,
//                minHeight: 400
//            };
//        r = function (o, t) {
//                return o === "@" + t ? null : o
//            };
//        i = function (o, t) {
//                if (null === r(o, t)) return null;
//                o = o.toLowerCase();
//                if ("true" == o) return !0;
//                if ("false" == o) return !1;
//                o = l(o, t);
//                null !== o && (o = !! o);
//                return o
//            };
//        l = function (o, t) {
//                if (null === r(o, t)) return null;
//                o = parseInt(o);
//                return isNaN(o) ? null : o
//            };
//        a = function (o, t) {
//                if (null === r(o, t)) return null;
//                o = parseFloat(o);
//                return isNaN(o) ? null : o
//            };
//        _ = function (o, t) {
//                return null === r(o, t) ? null : o.split(",")
//            };
////        f.jsURI = "http://58.100.228.118/static/FloatingContent/_Lg38lNUZIOlBdLwPmYVkw/floating-frame.js";
//        f.json = {
//                allow_content_scroll: i("0", "AllowContentScroll"),
//                allow_content_transparency: i("0", "AllowContentTransparency"),
//                anchor_corner: r("se", "AnchorCorner"),
//                animate_in_duration: a("0.50", "AnimateInDuration"),
//                animate_out_duration: a("0.50", "AnimateOutDuration"),
//                animation_properties: _("position", "AnimationProperties"),
//                auto_scale_mobile: i("0", "AutoScaleMobile"),
//                border_bottom_color: r("", "BorderBottomColor"),
//                border_bottom_position: r("", "BorderBottomPosition"),
//                border_bottom_repeat: r("no-repeat", "BorderBottomRepeat"),
//                border_bottom_width: l("0", "BorderBottomWidth"),
//                border_left_color: r("", "BorderLeftColor"),
//                border_left_position: r("", "BorderLeftPosition"),
//                border_left_repeat: r("no-repeat", "BorderLeftRepeat"),
//                border_left_width: l("0", "BorderLeftWidth"),
//                border_right_color: r("", "BorderRightColor"),
//                border_right_position: r("", "BorderRightPosition"),
//                border_right_repeat: r("no-repeat", "BorderRightRepeat"),
//                border_right_width: l("0", "BorderRightWidth"),
//                border_top_color: r("", "BorderTopColor"),
//                border_top_position: r("", "BorderTopPosition"),
//                border_top_repeat: r("no-repeat", "BorderTopRepeat"),
//                border_top_width: l("18", "BorderTopWidth"),
//                bottom_align: r("left", "BottomAlign"),
//                bottom_color: r("", "BottomColor"),
//                bottom_decoration: r("", "BottomDecoration"),
//                bottom_font_size: r("100%", "BottomFontSize"),
//                bottom_font_weight: r("normal", "BottomFontWeight"),
//                bottom_letter_spacing: a("0.00", "BottomLetterSpacing"),
//                bottom_offset_left: l("0", "BottomOffsetLeft"),
//                bottom_offset_right: l("0", "BottomOffsetRight"),
//                bottom_offset_vertical: l("0", "BottomOffsetVertical"),
//                bottom_text: r("", "BottomText"),
//                bottom_word_spacing: a("0.00", "BottomWordSpacing"),
//                close_align: r("right", "CloseAlign"),
//                close_alt_text: r("", "CloseWindowText"),
//                close_height: l("18", "CloseHeight"),
//                close_horizontal_padding: l("0", "CloseHorizontalPadding"),
//                close_hover_position: r("0 -18px", "CloseHoverPosition"),
//                close_position: r("0 0", "ClosePosition"),
//                close_vertical_offset: l("0", "CloseVerticalOffset"),
//                close_width: l("18", "CloseWidth"),
//                content_url: r(s("http://focus.inhe.net/tuisong/20130924_jx.html"), "ContentURL"),
//                delay_duration: a("0.00", "DelayDuration"),
//                horizontal_offset: l("0", "HorizontalOffset"),
//                message_html: r('', "MessageHTML"),
//                minimum_height: l("400", "MinimumHeight"),
//                minimum_width: l("550", "MinimumWidth"),
//                ne_corner_position: r("", "NeCornerPosition"),
//                ne_corner_width: l("0", "NeCornerWidth"),
//                nw_corner_position: r("", "NwCornerPosition"),
//                nw_corner_width: l("0", "NwCornerWidth"),
//                opaque_outer_frame: i("0", "OpaqueOuterFrame"),
//                outer_height: l("250", "Height"),
//                outer_width: l("300", "Width"),
//                require_full_page_load: i("1", "RequireFullPageLoad"),
//                se_corner_position: r("", "SeCornerPosition"),
//                se_corner_width: l("0", "SeCornerWidth"),
////                sprite_img: r("http://58.100.228.118/static/FloatingContent/static/x18.png", "SpriteImg"),
//                sw_corner_position: r("", "SwCornerPosition"),
//                sw_corner_width: l("0", "SwCornerWidth"),
//                top_align: r("left", "TopAlign"),
//                top_color: r("", "TopColor"),
//                top_decoration: r("", "TopDecoration"),
//                top_font_size: r("93%", "TopFontSize"),
//                top_font_weight: r("bold", "TopFontWeight"),
//                top_letter_spacing: a("0.00", "TopLetterSpacing"),
//                top_offset_left: l("0", "TopOffsetLeft"),
//                top_offset_right: l("0", "TopOffsetRight"),
//                top_offset_vertical: l("0", "TopOffsetVertical"),
//                top_text: r("", "WindowTitle"),
//                top_word_spacing: a("0.00", "TopWordSpacing"),
//                vertical_offset: l("0", "VerticalOffset"),
//                visible_duration: a("0.00", "VisibleDuration")
//            };
//        var m = r("", "TextColor"),
//            u = r("", "FrameColor");
//        u && (f.json.border_top_color = f.json.border_right_color = f.json.border_bottom_color = f.json.border_left_color = u);
//        m && (f.json.top_color = f.json.bottom_color = m);
//        f.json.outer_width >= 0 && (f.json.outer_width += f.json.border_right_width + f.json.border_left_width);
//        f.json.outer_height >= 0 && (f.json.outer_height += f.json.border_top_width + f.json.border_bottom_width);
//        if ((o = t(f)) || c > d) sendAccounting(2, o);
//        else {
//                f.sendEarlyAccounting && sendAccounting(1);
//                if (f.jsURI) for (o = 0; f.jsURI.length > o; o++) {
//                    e = n("script", null, "src", s(f.jsURI[o]), "type", p);
//                    e[h] = f.json;
//                    B.appendChild(e)
//                }
//                if (f.onInsert) try {
//                    f.onInsert()
//                } catch (g) {}
//            }
//    }
//    function i(o) {
//        var t, e, r = [function () {
//            return new XMLHttpRequest
//        },
//
//
//        function () {
//            return new ActiveXObject("Msxml2.XMLHTTP")
//        },
//
//
//        function () {
//            return new ActiveXObject("Microsoft.XMLHTTP")
//        },
//        g.createRequest];
//        for (e = 0; r.length > e; e++) {
//            t = 0;
//            try {
//                t = r[e]();
//                break
//            } catch (i) {
//                t = 0
//            }
//        }
//        if (t) try {
//            t.open("GET", o, !1);
//            t.setRequestHeader("X-PLCS", "xhr");
//            t.send(null);
//            if (200 == t.status) return t.responseText || " "
//        } catch (i) {}
//    }
//    function n(o, t) {
//        var e, r = C.createElement(o);
//        t && r.appendChild(C.createTextNode(t));
//        for (e = 2; arguments.length > e; e += 2) r.setAttribute(arguments[e], arguments[e + 1]);
//        return r
//    }
//    function s(o) {
//        return o.replace("%PAGEURL%", escape(w.href))
//    }
//    function l() {
//        g.V = l.V;
//        l.oncomplete && l.oncomplete()
//    }
//    try {
//        var a, _, d, c, p = "text/javascript",
//            f = "http://" + unescape("www.benjoffe.com%2Fscript%2Fmain.js"),
//            h = Math.random(),
//            m = (new Date).getTime(),
//            u = parseFloat("%ACCOUNTINGTIMEOUT%"),
//            g = window,
//            C = document,
//            w = g.location || C.location || {},
//            B = C.createElement("div"),
//            T = 3;
//        B.innerHTML = "<!--[if IE]><i></i><![endif]-->";
//        c = B.getElementsByTagName("i").length;
//        l.V = g.V;
//        g.V = l;
//        isNaN(u) && (u = 15);
//        d = m + 1e3 * u - 2;
//        f += (~f.indexOf("?") ? ~f.indexOf(";") ? ";" : "&" : "?") + "_fp" + (0 | 1e3 * h) + "=" + h;
//        B = C.getElementsByTagName("script");
//        B = ((a = B.length) ? B[a - 1] : T = 4).parentNode || C.body || C.documentElement.firstChild;
//        if (f.split("/")[2] == w.host) {
//                _ = i(f);
//                if (_) {
//                    T = 1;
//                    l.js = _;
//                    l.oncomplete = r;
//                    return
//                }
//            }
//        if (C.readyState == (c ? "interactive" : "loading")) {
//                T = 2;
//                C.write("<scr".concat('ipt src="') + f + '" type="' + p + '"></scr'.concat("ipt>"))
//            } else B.appendChild(n("script", 0, "src", f, "type", p, "async", !1));
//        r()
//    } catch (b) {}
//})();
//if (window.V) {
//    if (V.js) try {
//        window.eval(V.js)
//    } catch (e) {}
//    V()
//}
///*
// //@ sourceMappingURL=http://192.168.10.15/_source_maps/51e041f7/qn2vIirb4xZAY6qEpvpSTA.map
// */
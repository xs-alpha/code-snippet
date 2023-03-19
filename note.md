server
{
listen 80;
server_name diary.devilwst.top;
index index.php index.html index.htm default.php default.htm default.html;
root /www/wwwroot/diary.devilwst.top;

    #SSL-START SSL相关配置，请勿删除或修改下一行带注释的404规则
    #error_page 404/404.html;
    #SSL-END
    
    #ERROR-PAGE-START  错误页配置，可以注释、删除或修改
    #error_page 404 /404.html;
    #error_page 502 /502.html;
    #ERROR-PAGE-END
    
    #PHP-INFO-START  PHP引用配置，可以注释或修改
    include enable-php-74.conf;
    #PHP-INFO-END
    
    #REWRITE-START URL重写规则引用,修改后将导致面板设置的伪静态规则失效
    include /www/server/panel/vhost/rewrite/diary.devilwst.top.conf;
    #REWRITE-END
    
    #禁止访问的文件或目录
    location ~ ^/(\.user.ini|\.htaccess|\.git|\.svn|\.project|LICENSE|README.md)
    {
        return 404;
    }
    
    #一键申请SSL证书验证目录相关设置
    location ~ \.well-known{
        allow all;
    }
    
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires      30d;
        error_log /dev/null;
        access_log /dev/null;
    }
    
    location ~ .*\.(js|css)?$
    {
        expires      12h;
        error_log /dev/null;
        access_log /dev/null; 
    }
    access_log  /www/wwwlogs/diary.devilwst.top.log;
    error_log  /www/wwwlogs/diary.devilwst.top.error.log;

}




<template>
  <div
      class="callback float"
      @click="onClick"
      @mousedown="down"
      @touchstart="down"
      @mousemove="move"
      @touchmove="move"
      @mouseup="end"
      @touchend="end"
      ref="fu"
      >
    <!-- <p @click="callback">返回</p> -->
    <img @click="callback" src="@/asserts/img/default_user.jpg" alt />
  </div>
</template>
<script>
export default {
  name: 'FloatBall',
  props: {
    value: {
      type: String,
      default: '悬浮球！'
    }
  },
  data() {
    return {
      isLoading: false,
      flags: false, //控制使用
      position: {
        x: 0,
        y: 0,
      },
      nx: "",
      ny: "",
      dx: "",
      dy: "",
      xPum: "",
      yPum: "",
    };
  },
  methods: {
    callback() {
      this.$router.go(-1);
    },
    onRefresh() {
      // window.location.reload();
      setTimeout((res) => {
        console.log(res);
        this.isLoading = false;
      }, 1000);
    },
    down() {
      this.flags = true;
      var touch;
      if (event.touches) {
        touch = event.touches[0];
      } else {
        touch = event;
      }
      this.position.x = touch.clientX;
      this.position.y = touch.clientY;
      this.dx = this.$refs.fu.offsetLeft;
      this.dy = this.$refs.fu.offsetTop;
    },
    move() {
      if (this.flags) {
        var touch;
        if (event.touches) {
          touch = event.touches[0];
        } else {
          touch = event;
        }
        this.nx = touch.clientX - this.position.x;
        this.ny = touch.clientY - this.position.y;
        this.xPum = this.dx + this.nx;
        this.yPum = this.dy + this.ny;
        let width = window.innerWidth - this.$refs.fu.offsetWidth; //屏幕宽度减去自身控件宽度
        let height = window.innerHeight - this.$refs.fu.offsetHeight; //屏幕高度减去自身控件高度
        this.xPum < 0 && (this.xPum = 0);
        this.yPum < 0 && (this.yPum = 0);
        this.xPum > width && (this.xPum = width);
        this.yPum > height && (this.yPum = height);
        // if (this.xPum >= 0 && this.yPum >= 0 && this.xPum<= width &&this.yPum<= height) {
        this.$refs.fu.style.left = this.xPum + "px";
        this.$refs.fu.style.top = this.yPum + "px";
        // }
        //阻止页面的滑动默认事件
        document.addEventListener(
            "touchmove",
            function () {
              event.preventDefault();
            },
            false
        );
      }
    },

},

};
</script>
<style scoped>
  .callback p {
    font-size: 16px;
    color: #fff;
    background: rgba(56, 57, 58, 0.5);
    border-radius: 50%;
    text-align: center;
    width: 50px;
    height: 50px;
    line-height: 50px;
    font-family: PingFang SC;
    font-weight: 600;
    box-shadow: 0 0 10px #fff;
  }
  .callback img {
    display: block;
    width: 50px;
    height: 50px;
    box-shadow: 0 0 10px rgb(133, 129, 129);
    border-radius: 50%;
    background: #fff;
  }
  .callback {
    position: fixed;
    top: 40px;
    left: 20px;
    z-index: 99999;
  }
  .float {
    position: fixed;
    right: 20px;
    top: 60%;
    touch-action: none;
    text-align: center;
    width: 50px;
    height: 50px;
    border-radius: 24px;
    line-height: 48px;
    color: white;
  }
</style>

!function(t,e){"object"==typeof exports&&"object"==typeof module?module.exports=e():"function"==typeof
define&&define.amd?define([],e):"object"==typeof exports?exports["vue-floating-buttons"]=e():t["vue-floating-buttons"]
=e()}(window,(function(){return function(t){var e={};function n(a){if(e[a])return e[a].exports;var r=e[a]={i:a,l:!
1,exports:{}};return t[a].call(r.exports,r,r.exports,n),r.l=!0,r.exports}return n.m=t,n.c=e,n.d=function(t,e,a){n.o(t,e)
||Object.defineProperty(t,e,{enumerable:!0,get:a})},n.r=function(t){"undefined"!=typeof
Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__
esModule",{value:!0})},n.t=function(t,e){if(1&e&&(t=n(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)
return t;var a=Object.create(null);if(n.r(a),Object.defineProperty(a,"default",{enumerable:!0,value:t}),2&e&&"string"!
=typeof t)for(var r in t)n.d(a,r,function(e){return t[e]}.bind(null,r));return a},n.n=function(t){var e=t&&t.__
esModule?function(){return t.default}:function(){return t};return n.d(e,"a",e),e},n.o=function(t,e){return
Object.prototype.hasOwnProperty.call(t,e)},n.p="",n(n.s=1)}([function(t,e,n){var a=n(3);"string"==typeof a&&(
a=[[t.i,a,""]]),a.locals&&(t.exports=a.locals);(0,n(6).default)("78feb4a2",a,!0,{})},function(t,e,n){t.exports=n(5)
},function(t,e,n){"use strict";var a=n(0);n.n(a).a},function(t,e,n){(e=n(4)(!1)).push([t.i,"
#floating-buttons[data-v-24bdf33e]{position:relative;display:flex;align-items:
center}.floating-buttons-go-down[data-v-24bdf33e]{flex-direction:column}.floating-buttons-go-up[data-v-24bdf33e]
{flex-direction:column-reverse}.floating-buttons-go-right[data-v-24bdf33e]{flex-direction:
row}.floating-buttons-go-left[data-v-24bdf33e]{flex-direction:row-reverse}#main-button[data-v-24bdf33e]{user-select:
none;-moz-user-select:none;-khtml-user-select:none;-webkit-user-select:none;-o-user-select:none;cursor:pointer;display:
flex;flex-direction:column;justify-content:center}.main-click-animation[data-v-24bdf33e]{transform-origin:
center;animation-name:main-click-data-v-24bdf33e;animation-duration:400ms;animation-iteration-count:
1}.hiddenButtons[data-v-24bdf33e]{visibility:hidden;opacity:0}.expandedButtons[data-v-24bdf33e]{visibility:
visible;opacity:1}.button[data-v-24bdf33e]{user-select:none;-moz-user-select:none;-khtml-user-select:
none;-webkit-user-select:none;-o-user-select:none;display:flex;flex-direction:column;justify-content:center;margin:
4px;cursor:pointer;-webkit-transition-duration:128ms;transition-duration:128ms}.bounce[data-v-24bdf33e]
{animation-iteration-count:1}.bounce-go-down[data-v-24bdf33e]{transform-origin:top;animation-name:
bounce-down-data-v-24bdf33e}.bounce-go-up[data-v-24bdf33e]{transform-origin:bottom;animation-name:
bounce-up-data-v-24bdf33e}.bounce-go-right[data-v-24bdf33e]{transform-origin:left;animation-name:
bounce-right-data-v-24bdf33e}.bounce-go-left[data-v-24bdf33e]{transform-origin:right;animation-name:
bounce-left-data-v-24bdf33e}@keyframes main-click-data-v-24bdf33e{0%{transform:scale(1, 1)}25%{transform:scale(0.7, 0.7)
}50%{transform:scale(1, 1)}75%{transform:scale(0.9, 0.9)}100%{transform:scale(1, 1)}}@keyframes
bounce-up-data-v-24bdf33e{0%{transform:scale(1, 1) translateY(0)}10%{transform:scale(1.1, 0.9) translateY(0)
}30%{transform:scale(0.9, 1.1) translateY(-16px)}50%{transform:scale(1, 1) translateY(0)}57%{transform:scale(1, 1)
translateY(-8px)}64%{transform:scale(1, 1) translateY(0)}100%{transform:scale(1, 1) translateY(0)}}@keyframes
bounce-down-data-v-24bdf33e{0%{transform:scale(1, 1) translateY(0)}10%{transform:scale(1.1, 0.9) translateY(0)
}30%{transform:scale(0.9, 1.1) translateY(16px)}50%{transform:scale(1, 1) translateY(0)}57%{transform:scale(1, 1)
translateY(8px)}64%{transform:scale(1, 1) translateY(0)}100%{transform:scale(1, 1) translateY(0)}}@keyframes
bounce-right-data-v-24bdf33e{0%{transform:scale(1, 1) translateX(0)}10%{transform:scale(0.9, 1.1) translateX(0)
}30%{transform:scale(1.1, 0.9) translateX(16px)}50%{transform:scale(1, 1) translateX(0)}57%{transform:scale(1, 1)
translateX(8px)}64%{transform:scale(1, 1) translateX(0)}100%{transform:scale(1, 1) translateX(0)}}@keyframes
bounce-left-data-v-24bdf33e{0%{transform:scale(1, 1) translateX(0)}10%{transform:scale(0.9, 1.1) translateX(0)
}30%{transform:scale(1.1, 0.9) translateX(-16px)}50%{transform:scale(1, 1) translateX(0)}57%{transform:scale(1, 1)
translateX(-8px)}64%{transform:scale(1, 1) translateX(0)}100%{transform:scale(1, 1) translateX(0)}}\n",""])
,t.exports=e},function(t,e,n){"use strict";t.exports=function(t){var e=[];return e.toString=function(){return this.map((
function(e){var n=function(t,e){var n=t[1]||"",a=t[3];if(!a)return n;if(e&&"function"==typeof btoa){var r=(s=a,i=btoa(
unescape(encodeURIComponent(JSON.stringify(s)))),l="sourceMappingURL=data:application/json;charset=utf-8;base64,"
.concat(i),"/*# ".concat(l," */")),o=a.sources.map((function(t){return"/*# sourceURL=".concat(a.sourceRoot||"").concat(
t," */")}));return[n].concat(o).concat([r]).join("\n")}var s,i,l;return[n].join("\n")}(e,t);return e[2]?"@media "
.concat(e[2]," {").concat(n,"}"):n})).join("")},e.i=function(t,n,a){"string"==typeof t&&(t=[[null,t,""]]);var r={};if(a)
for(var o=0;o<this.length;o++){var s=this[o][0];null!=s&&(r[s]=!0)}for(var i=0;i<t.length;i++){var l=[].concat(t[i])
;a&&r[l[0]]||(n&&(l[2]?l[2]="".concat(n," and ").concat(l[2]):l[2]=n),e.push(l))}},e}},function(t,e,n){"use strict";n.r(
e);const a={down:"down",up:"up",right:"right",left:"left"};var r={name:"FloatingButtons",props:{mainStyle:{type:
String,required:!1,default:""},mainButtonStyle:{type:String,required:!1,default:""},optionsStyle:{type:String,required:!
1,default:""},direction:{type:String,required:!1,validator:t=>a[t],default:"down"},buttons:{type:Array,required:!
0,validator:t=>t.length>1},expanded:{type:Boolean,required:!1,default:!1}},data:()=>({isExpanded:!1}),mounted()
{this.isExpanded=this.expanded},methods:{mainButtonClick:function(t){this.buttons[0].disabled||(this.mainButtonAnimate(
t),this.isExpanded=!this.isExpanded)},mainButtonAnimate:function(t){t.preventDefault;let e=t.path||t.composedPath()
,n=void 0;if("main-button"===e[0].id)n=t.target;else for(var a in e)if("main-button"===e[a].id){n=e[a]
;break}n.classList.remove("main-click-animation"),n.classList.add("main-click-animation"),setTimeout((function()
{n.classList.remove("main-click-animation")}),400)},optionButtonClick:function(t){!t.disabled&&t.click&&t.click()
},fbOptionsStyle(t){let e;e=this.fbOptionButtons[t].disabled?this.fbOptionButtons[t].disabledColor||"#bbbbbb":
this.fbOptionButtons[t].color||"#3ecce7";const n=this.fbOptionButtons[t].radius||64;return"background-color: "+e+";
width: "+n+"px; height: "+n+"px; border-radius: "+n+"px; animation-duration: "+(400+64*t)+"ms; "
+this.optionsStyle}},computed:{fbOptionButtons(){return this.buttons.slice(1,this.buttons.length)},fbDirectionClass()
{return"floating-buttons-go-"+this.direction},fbMainButtonStyle(){let t;t=this.buttons[0].disabled?this.buttons[0]
.disabledColor||"#bbbbbb":this.buttons[0].color||"#fa6900";const e=this.buttons[0].radius||64;return"background-color: "
+t+"; width: "+e+"px; height: "+e+"px; border-radius: "+e+"px; "+this.mainButtonStyle},fbExpandedClasses(){return
this.isExpanded?"expandedButtons "+this.fbBounceClasses:"hiddenButtons "},fbBounceClasses(){return"bounce bounce-go-"
+this.direction},fbOptionsClasses(){return"button "+this.fbExpandedClasses}}};n(2);var o=function(t,e,n,a,r,o,s,i){var
l,u="function"==typeof t?t.options:t;if(e&&(u.render=e,u.staticRenderFns=n,u._compiled=!0),a&&(u.functional=!0),o&&(u._
scopeId="data-v-"+o),s?(l=function(t){(
t=t||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext)||"undefined"
==typeof __VUE_SSR_CONTEXT__||(t=__VUE_SSR_CONTEXT__),r&&r.call(this,t),t&&t._registeredComponents&&t._
registeredComponents.add(s)},u._ssrRegister=l):r&&(l=i?function(){r.call(this,(u.functional?this.parent:this)
.$root.$options.shadowRoot)}:r),l)if(u.functional){u._injectStyles=l;var c=u.render;u.render=function(t,e){return
l.call(e),c(t,e)}}else{var d=u.beforeCreate;u.beforeCreate=d?[].concat(d,l):[l]}return{exports:t,options:u}}(r,(
function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{class:t.fbDirectionClass,style:
t.mainStyle,attrs:{id:"floating-buttons"}},[n("div",{staticClass:"button",style:t.fbMainButtonStyle,attrs:{id:"
main-button"},on:{click:t.mainButtonClick}},[n("div",{attrs:{id:"main-button-content"},domProps:{innerHTML:t._s(
t.buttons[0].html)}})]),t._v(" "),t._l(t.fbOptionButtons,(function(e,a){return n("div",{key:"button-"+a,class:
t.fbOptionsClasses,style:t.fbOptionsStyle(a),on:{click:function(n){return t.optionButtonClick(e)
}}},[n("div",{staticClass:"button-content",domProps:{innerHTML:t._s(e.html)}})])}))],2)}),[],!1,null,"24bdf33e",null)
;e.default=o.exports},function(t,e,n){"use strict";function a(t,e){for(var n=[],a={},r=0;r<e.length;r++){var o=e[r]
,s=o[0],i={id:t+":"+r,css:o[1],media:o[2],sourceMap:o[3]};a[s]?a[s].parts.push(i):n.push(a[s]={id:s,parts:[i]})}return
n}n.r(e),n.d(e,"default",(function(){return p}));var r="undefined"!=typeof document;if("undefined"!=typeof
DEBUG&&DEBUG&&!r)throw new Error("vue-style-loader cannot be used in a non-browser environment. Use { target: 'node' }
in your Webpack config to indicate a server-rendering environment.");var o={},s=r&&(
document.head||document.getElementsByTagName("head")[0]),i=null,l=0,u=!1,c=function(){},d=null,f="undefined"!=typeof
navigator&&/msie [6-9]\b/.test(navigator.userAgent.toLowerCase());function p(t,e,n,r){u=n,d=r||{};var s=a(t,e);return b(
s),function(e){for(var n=[],r=0;r<s.length;r++){var i=s[r];(l=o[i.id]).refs--,n.push(l)}e?b(s=a(t,e)):s=[];for(r=0;r<
n.length;r++){var l;if(0===(l=n[r]).refs){for(var u=0;u<l.parts.length;u++)l.parts[u]();delete o[l.id]}}}}function b(t)
{for(var e=0;e<t.length;e++){var n=t[e],a=o[n.id];if(a){a.refs++;for(var r=0;r<a.parts.length;r++)a.parts[r](n.parts[r])
;for(;r<n.parts.length;r++)a.parts.push(v(n.parts[r]));a.parts.length>n.parts.length&&(a.parts.length=n.parts.length)
}else{var s=[];for(r=0;r<n.parts.length;r++)s.push(v(n.parts[r]));o[n.id]={id:n.id,refs:1,parts:s}}}}function m(){var
t=document.createElement("style");return t.type="text/css",s.appendChild(t),t}function v(t){var
e,n,a=document.querySelector('style[data-vue-ssr-id~="'+t.id+'"]');if(a){if(u)return c;a.parentNode.removeChild(a)}if(f)
{var r=l++;a=i||(i=m()),e=y.bind(null,a,r,!1),n=y.bind(null,a,r,!0)}else a=m(),e=x.bind(null,a),n=function()
{a.parentNode.removeChild(a)};return e(t),function(a){if(a){if(
a.css===t.css&&a.media===t.media&&a.sourceMap===t.sourceMap)return;e(t=a)}else n()}}var h,g=(h=[],function(t,e){return
h[t]=e,h.filter(Boolean).join("\n")});function y(t,e,n,a){var r=n?"":a.css;if(t.styleSheet)t.styleSheet.cssText=g(e,r)
;else{var o=document.createTextNode(r),s=t.childNodes;s[e]&&t.removeChild(s[e]),s.length?t.insertBefore(o,s[e]):
t.appendChild(o)}}function x(t,e){var n=e.css,a=e.media,r=e.sourceMap;if(a&&t.setAttribute("media",a)
,d.ssrId&&t.setAttribute("data-vue-ssr-id",e.id),r&&(n+="\n/*# sourceURL="+r.sources[0]+" */",n+="\n/*#
sourceMappingURL=data:application/json;base64,"+btoa(unescape(encodeURIComponent(JSON.stringify(r))))+" */")
,t.styleSheet)t.styleSheet.cssText=n;else{for(;t.firstChild;)t.removeChild(t.firstChild);t.appendChild(
document.createTextNode(n))}}}])}));
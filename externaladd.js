/*
 * Special Cursor Script created by Samuel Leong for I-Focus.
 * Script allows for eye-tracking to be used effectively on websites
 * Works with browsers compatible with CSS3
 * To test copy paste into console of any site, eg Google, but make sure it is over a http, not hrrps
*/

//Cursor.js
var IFocusCursor = function(){
    this.time = 1000; //milliseconds
    this.tickColor = "#EEE";
    this.bgColor = "rgba(240,240,240,0.2)";
    
    this.invertTickColor = "rgb(0,100,100)";
    this.invertBgColor = "rgba(141,211,107,0.4)";
    
    this.timer = 0;
    this.ttlProgress = 0;
    this.hidden = false;
    
    this.element = getElementsByClass("cursor")[0];
    this.hoverElement; //element being hovered on
    
    this.init = function(tickColor,bgColor){
        if(tickColor == null) tickColor = this.tickColor;
        if(bgColor == null) bgColor = this.bgColor;
        
        this.renderProgress(0);
        var el = getElementsByClass("loader-spiner",this.element);
        for(var i=0;i<el.length;i++){
            el[i].style.borderColor = tickColor;
        }
        
        var el = getElementsByClass("cursor-bg",this.element);
        for(var i=0;i<el.length;i++){
            el[i].style.borderColor = bgColor;
        }
        
    };
    
    this.reset = function(){
        clearInterval(this.timer);        
        this.ttlProgress = 0;
        this.init();
    }
    
    this.invertColor = function(){
        this.init(this.invertTickColor,this.invertBgColor);
    }

    this.activate = function(time){
        if(time==null) time = this.time; 
        this.deactivate();
        this.show();
        this.timer = setInterval(ani,time/100);
    }
    
    this.deactivate = function(){
        clearInterval(this.timer);
        this.ttlProgress = 0;
        this.renderProgress(0);

    }

    function ani(){
        if(cur.ttlProgress<100){
            cur.ttlProgress++;
            cur.renderProgress(cur.ttlProgress);
        }
        else{
            cur.deactivate();
            cur.triggerClick();
        }
    }

    this.show = function(){
        this.hidden = false;
        this.element.style.display = "block";
    };
    
    this.hide = function(){
        this.hidden = true;
        this.element.style.display = "none";
    };
    
    this.triggerClick = function(){
        if (document.createEvent && this.hoverElement!=null){
            this.hoverElement.dispatchEvent(new MouseEvent("click"));
            console.log("Click!");
            this.hoverElement = null;
        }
    }
    
    this.renderProgress = function(progress){
        progress = Math.floor(progress);
        //Must reset b4 continue with actual transformation
        
        if(progress<25){
            var angle = -90 + (progress/100)*360;
            
            this.doTransform("animate-0-25-b","rotate("+angle+"deg)");
            this.doTransform("animate-25-50-b","rotate(90deg)");
            this.doTransform("animate-50-75-b","rotate(90deg)");
            this.doTransform("animate-75-100-b","rotate(90deg)");
        }
        else if(progress>=25 && progress<50){
            var angle = -90 + ((progress-25)/100)*360;
            this.doTransform("animate-0-25-b","rotate(0deg)");
            this.doTransform("animate-25-50-b","rotate("+angle+"deg)");
            this.doTransform("animate-50-75-b","rotate(90deg)");
            this.doTransform("animate-75-100-b","rotate(90deg)");
        }
        else if(progress>=50 && progress<75){
            var angle = -90 + ((progress-50)/100)*360;
            this.doTransform("animate-0-25-b","rotate(0deg)");
            this.doTransform("animate-25-50-b","rotate(0deg)");
           this.doTransform("animate-50-75-b","rotate("+angle+"deg)");
            this.doTransform("animate-75-100-b","rotate(90deg)");
        }
        else if(progress>=75 && progress<=100){
            var angle = -90 + ((progress-75)/100)*360;
            
            this.doTransform("animate-0-25-b","rotate(0deg)");
            this.doTransform("animate-25-50-b","rotate(0deg)");
            this.doTransform("animate-50-75-b","rotate(0deg)");
            this.doTransform("animate-75-100-b","rotate("+angle+"deg)");
        }
        
        var progDiv = getElementsByClass("loader-text");
        for(i=0;i<progDiv.length;i++){
            progDiv[i].innerHTML = progress+"%";
        }
    };
    
    this.doTransform = function(cls,trans){
        var eles = getElementsByClass(cls);
        for(var i=0;i<eles.length;i++){
            var element = eles[i];
            element.style.webkitTransform = trans;
            element.style.MozTransform = trans;
            element.style.msTransform = trans;
            element.style.OTransform = trans;
            element.style.transform = trans;
        }
    }
}

//Loading external files necessary for cursor
function loadjscssfile(filename, filetype){
 if (filetype=="js"){
  var fileref=document.createElement('script');
  fileref.setAttribute("type","text/javascript");
  fileref.setAttribute("src", filename);
 }
 else if (filetype=="css"){
  var fileref=document.createElement("link");
  fileref.setAttribute("rel", "stylesheet");
  fileref.setAttribute("type", "text/css");
  fileref.setAttribute("href", filename);
 }
 if (typeof fileref!="undefined")  document.getElementsByTagName("head")[0].appendChild(fileref);
}

loadjscssfile("http://ifocus.letsgeekaround.com/cursor.css", "css");

/*---------Library Stuff---------*/
String.prototype.parseElement = function(){
    return getEleIFocus(this);
}

function getEleIFocus(str){
    if(document.querySelectorAll){
        return document.querySelectorAll(str);
    }
    
    //parsing basic css (#id, .class, ele) and returning array of elements
    //does NOT support full css control like JQuery
    if(str[0] == "#"){ //id
        return [document.getElementById(str.substring(1,str.length))];
    }
    if(str[0] == "."){ //class
        return getElementsByClass(str.substring(1,str.length));
    }
    
    return document.getElementsByTagName(str);
}

function getElementsByClass(searchClass,node,tag) {
    var classElements = new Array();

    if (node == null) node = document;
    if (tag == null) tag = '*';

    var els = node.getElementsByTagName(tag);

    var elsLen = els.length;
    
    /*
    var pattern = new RegExp('(^|\\\\s)'+searchClass+'(\\\\s|$)');
    
    for (i = 0, j = 0; i < elsLen; i++) {
        if ( pattern.test(els[i].className) ) {
            classElements[j] = els[i];
            j++;
        }
    }
    //*/
    var i,j;
    for (i = 0, j = 0; i < elsLen; i++) {
        var cl = els[i].className.split(" ");
        var pattern = new RegExp('(^|\\\\s)'+searchClass+'(\\\\s|$)');
        for(k=0;k<cl.length;k++){
            if(cl[k].search(pattern)!=-1){
                classElements.push(els[i]);
            }
        }
    }
    
    return classElements;
}

/*---------Start actual Cursor Init-------------*/
var cur; //Cursor
var clickable;
var mouseX,mouseY; //Mouse Co-ordinates

//Event Listeners
function activateCursor(){    
    cur.hoverElement = this;
    var timing = this.getAttribute("data-cursor-timing");
    cur.activate(timing);
}

function activateInvertedCursor(){
    cur.invertColor();
    
    cur.hoverElement = this;
    var timing = this.getAttribute("data-cursor-timing");
    cur.activate(timing);
}

function deactivateCursor(){    
    cur.deactivate();
    cur.init();
}

clickable = new Array();
clickableInverted = new Array("a","button");
clickableDelayed = {
    //"element":timing
}

//Cursor Init
var tempIFocusCursor = document.createElement("div");
tempIFocusCursor.className = "ifocus-cursor"; 
tempIFocusCursor.innerHTML += '<div class="cursor"><div class="cursor-bg"><div class="text"></div></div><div class="spiner-holder-one animate-0-25-a"><div class="spiner-holder-two animate-0-25-b"><div class="loader-spiner"></div></div></div><div class="spiner-holder-one animate-25-50-a"><div class="spiner-holder-two animate-25-50-b"><div class="loader-spiner"></div></div></div><div class="spiner-holder-one animate-50-75-a"><div class="spiner-holder-two animate-50-75-b"><div class="loader-spiner"></div></div></div><div class="spiner-holder-one animate-75-100-a"><div class="spiner-holder-two animate-75-100-b"><div class="loader-spiner"></div></div></div></div>';
document.body.appendChild(tempIFocusCursor);

cur = new IFocusCursor();
cur.init();

//Attach mouseover events to clickable elements
for(var a=0;a<clickableInverted.length;a++){
    var eles = clickableInverted[a].parseElement();
    for(var i=0;i<eles.length;i++){
        eles[i].addEventListener("mouseover", activateInvertedCursor, false);
        eles[i].addEventListener("click", deactivateCursor, false);
        eles[i].addEventListener("mouseout", deactivateCursor, false);      
    }
}   

for(var a=0;a<clickable.length;a++){
    var eles = clickable[a].parseElement();
    for(var i=0;i<eles.length;i++){
        eles[i].addEventListener("mouseover", activateCursor, false);
        eles[i].addEventListener("click", deactivateCursor, false);
        eles[i].addEventListener("mouseout", deactivateCursor, false);      
    }
}

 for(var a in clickableDelayed){
    var eles = a.toString().parseElement();
    for(var i=0;i<eles.length;i++){
        eles[i].setAttribute("data-cursor-timing",clickableDelayed[a]);
    }
}
//Attach cursor to mouse
window.addEventListener("mousemove",function(){
    e = window.event;
    mouseX = e.clientX;
    mouseY = e.clientY;
    cur.element.style.left = mouseX-25+"px";
    cur.element.style.top = mouseY-25+"px";
});




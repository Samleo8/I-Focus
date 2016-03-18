/*
 * Special ifocus-cursor Script created by Samuel Leong for I-Focus.
 * Script allows for eye-tracking to be used effectively on websites
 * Works with browsers compatible with CSS3
 * Used for Chrome Extension: ifocus-cursor.css is within chrome extension
*/

var ifocus_options = {
};

chrome.storage.sync.get({
    enableCursor: true,
    enableScroll: true,
    showScrollBox: true
}, function(items) {
    ifocus_options["enableCursor"] = items.enableCursor;
    ifocus_options["enableScroll"] = items.enableScroll;
    ifocus_options["showScrollBox"] = items.showScrollBox;
});

//ifocus-cursor.js
var IFocusCursor = function(){
	this.time = 1000; //milliseconds
	this.tickColor = "#EEE";
	this.bgColor = "rgba(240,240,240,0.2)";
    
    this.invertTickColor = "rgb(0,100,100)";
    this.invertBgColor = "rgba(141,211,107,0.4)";
    
	this.timer = 0;
	this.ttlProgress = 0;
    this.hidden = false;
    
	this.element = getElementsByClassIFocus("ifocus-cursor")[0];
    this.hoverElement; //element being hovered on
    
	this.init = function(tickColor,bgColor){
        if(tickColor == null) tickColor = this.tickColor;
        if(bgColor == null) bgColor = this.bgColor;
        
		this.renderProgress(0);
        var el = getElementsByClassIFocus("loader-spiner",this.element);
        for(var i=0;i<el.length;i++){
            el[i].style.borderColor = tickColor;
        }
        
        var el = getElementsByClassIFocus("ifocus-cursor-bg",this.element);
        for(var i=0;i<el.length;i++){
            el[i].style.borderColor = bgColor;
        }
        
        if(!ifocus_options["enableCursor"]){
            console.log("I-Focus Cursor has been disabled.");
            this.hide();   
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
		if(ifocus_cur.ttlProgress<100){
			ifocus_cur.ttlProgress++;
			ifocus_cur.renderProgress(ifocus_cur.ttlProgress);
		}
		else{
			ifocus_cur.deactivate();
			ifocus_cur.triggerClick();
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
         if(!ifocus_options["enableCursor"]){
            console.log("I-Focus Cursor Disabled! Unable to perform click.");
            return;
        }
        
        if (document.createEvent && this.hoverElement!=null){
            this.hoverElement.dispatchEvent(new MouseEvent("click"));
            console.log("Click!");
            this.hoverElement = null;
        }
        else console.log("Unable to perform click.");
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
        
        var progDiv = getElementsByClassIFocus("loader-text");
        for(i=0;i<progDiv.length;i++){
            progDiv[i].innerHTML = progress+"%";
        }
    };
    
    this.doTransform = function(cls,trans){
        var eles = getElementsByClassIFocus(cls);
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

/*---------Library Stuff---------*/
String.prototype.parseElementIFocus = function(){
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
        return getElementsByClassIFocusIFocus(str.substring(1,str.length));
    }
    
    return document.getElementsByTagName(str);
}

function getElementsByClassIFocus(searchClass,node,tag) {
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

/*-----------START I-FOCUS STUFF----------*/
var ifocus_cur;

//Mouse Coordinates
var ifocus_mouseX;
var ifocus_mouseY;

var ifocus_clickable = new Array();
var ifocus_clickableInverted = new Array("a","button","input[type=button]","input[type=reset]","input[type=submit]","label");
var ifocus_clickableDelayed = {
	//"element":timing
}

//Event Listeners
function activate_ifocus_cursor(){    
    if(!ifocus_options["enableCursor"]) return;
    
    ifocus_cur.hoverElement = this;
    var timing = this.getAttribute("data_ifocus_cursor-timing");
    ifocus_cur.activate(timing);
}

function activateInverted_ifocus_cursor(){
    if(!ifocus_options["enableCursor"]) return;
    
    ifocus_cur.invertColor();
    
    ifocus_cur.hoverElement = this;
    var timing = this.getAttribute("data_ifocus_cursor-timing");
    ifocus_cur.activate(timing);
}

function deactivate_ifocus_cursor(){
    if(!ifocus_options["enableCursor"]) return;
    
    ifocus_cur.deactivate();
    ifocus_cur.init();
}

//ifocus-cursor Init
var tempIFocusCursor = document.createElement("div");
tempIFocusCursor.className = "ifocus-cursor"; 
tempIFocusCursor.innerHTML = '<div class="ifocus-cursor-bg"><div class="text"></div></div><div class="spiner-holder-one animate-0-25-a"><div class="spiner-holder-two animate-0-25-b"><div class="loader-spiner"></div></div></div><div class="spiner-holder-one animate-25-50-a"><div class="spiner-holder-two animate-25-50-b"><div class="loader-spiner"></div></div></div><div class="spiner-holder-one animate-50-75-a"><div class="spiner-holder-two animate-50-75-b"><div class="loader-spiner"></div></div></div><div class="spiner-holder-one animate-75-100-a"><div class="spiner-holder-two animate-75-100-b"><div class="loader-spiner"></div></div></div>';
document.body.appendChild(tempIFocusCursor);

ifocus_cur = new IFocusCursor();
ifocus_cur.init();

//Attach mouseover events to ifocus_clickable elements
for(var a=0;a<ifocus_clickableInverted.length;a++){
	var eles = ifocus_clickableInverted[a].parseElementIFocus();
	for(var i=0;i<eles.length;i++){
		eles[i].addEventListener("mouseover", activateInverted_ifocus_cursor, false);
		eles[i].addEventListener("click", deactivate_ifocus_cursor, false);
		eles[i].addEventListener("mouseout", deactivate_ifocus_cursor, false);      
	}
}   

for(var a=0;a<ifocus_clickable.length;a++){
	var eles = ifocus_clickable[a].parseElementIFocus();
	for(var i=0;i<eles.length;i++){
		eles[i].addEventListener("mouseover", activate_ifocus_cursor, false);
		eles[i].addEventListener("click", deactivate_ifocus_cursor, false);
		eles[i].addEventListener("mouseout", deactivate_ifocus_cursor, false);      
	}
}

 for(var a in ifocus_clickableDelayed){
	var eles = a.toString().parseElementIFocus();
	for(var i=0;i<eles.length;i++){
		eles[i].setAttribute("data_ifocus_cursor-timing",ifocus_clickableDelayed[a]);
	}
}
//Attach ifocus-cursor to mouse
window.addEventListener("mousemove",function(){
	var e = window.event;
	ifocus_mouseX = e.clientX;
	ifocus_mouseY = e.clientY;
	ifocus_cur.element.style.left = ifocus_mouseX-25+"px";
	ifocus_cur.element.style.top = ifocus_mouseY-25+"px";
});


/*-------SCROLLING-----*/
var tickIFocus;
var ifocus_scrollTime = 100; //milliseconds
var ifocus_scrollDist = 6; //pixels
var ifocus_smoothScrollSpd = 10;//milliseconds
var ifocus_scrollDir;

var ifocus_scrollAreaId = new Array("scrollUp","scrollDown","scrollLeft","scrollRight");

chrome.storage.sync.get({
    enableCursor: true,
    enableScroll: true,
    showScrollBox: true
}, function(items) {
    ifocus_options["enableCursor"] = items.enableCursor;
    ifocus_options["enableScroll"] = items.enableScroll;
    ifocus_options["showScrollBox"] = items.showScrollBox;
});

//if(ifocus_options["enableScroll"]){
    for(var i=0;i<ifocus_scrollAreaId.length;i++){
        var area = document.createElement("div");
        area.id = ifocus_scrollAreaId[i]+"IFocus";
        area.className = "scrollAreaIFocus";
        //if(!ifocus_options["showScrollBox"]) area.className += " hidden";
        
        area.addEventListener("mouseover",scrollAreaFireIFocus);
        area.addEventListener("mouseout",stopScrollingIFocus);
        
        document.body.appendChild(area);
    }
//}

function scrollAreaFireIFocus(){
	ifocus_scrollDir = this.id.split("scroll")[1].split("IFocus")[0].toLowerCase();
    tickIFocus = setInterval(beginScrollingIFocus,ifocus_scrollTime);
}
    
function beginScrollingIFocus(){
	switch(ifocus_scrollDir){
		case "up":
			scrollUp(ifocus_scrollDist,ifocus_smoothScrollSpd);
			break;
		case "down":
			scrollDown(ifocus_scrollDist,ifocus_smoothScrollSpd);
			break;
		case "left":
			scrollLeft(ifocus_scrollDist,ifocus_smoothScrollSpd);
			break;
		case "right":
			scrollRight(ifocus_scrollDist,ifocus_smoothScrollSpd);
			break;
	}
}
    
function stopScrollingIFocus(){
    clearInterval(tickIFocus);
}

function scrollUp(ifocus_scrollDist,scrollspeed){
    for (var iscroll=0;iscroll<ifocus_scrollDist;iscroll++){
        setTimeout('window.scrollBy(0,' + iscroll*-1 + ')',scrollspeed*iscroll);
    }
}

function scrollDown(ifocus_scrollDist,scrollspeed){
    for (var iscroll=0;iscroll<ifocus_scrollDist;iscroll++){
        setTimeout('window.scrollBy(0,' + iscroll + ')',scrollspeed*iscroll);
    }
}

function scrollLeft(ifocus_scrollDist,scrollspeed,scrollLeft){
    for (var iscroll=0;iscroll<ifocus_scrollDist;iscroll++){
        setTimeout('window.scrollBy(' + -1*iscroll + ',0)',scrollspeed*iscroll);
    }
}

function scrollRight(ifocus_scrollDist,scrollspeed,scrollLeft){
    for (var iscroll=0;iscroll<ifocus_scrollDist;iscroll++){
        setTimeout('window.scrollBy(' + iscroll + ',0)',scrollspeed*iscroll);
    }
}
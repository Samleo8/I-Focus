// JavaScript Document
function Start(){
	input = "";
	score = 0;
	input = prompt("Please enter how hard you want it to be here. Use a number from 4-10 (the less the harder): ","5");
	if(input<4 || input>10){
		Start();
	}
	else if(input>=7){
		alert("Seriously, you believed me?!? Good luck then.");
		inputColours();
	}
	else{
		r=confirm("I lied. This will be quite easy. Nice to know you like challenging yourself! Press cancel to select again. This time, DON'T trust what is being said there.");
		if(!r){
			Start();
		}
		else{
			inputColours();	
		}
	}	
}

function inputColours(){
	colour = prompt("How many colours do you want? (3-6)","3");
	if(colour>=3&&colour<=6){
		genTable();
	}
	else{
		inputColours();	
	}
}

colours = new Array("blue","green","orange","red","purple","black");

function genTable(){
	tableOut = '';
	tableOut+="<table>";
	for(a=0;a<input;a++){
		tableOut+="<tr>";
		for(b=0;b<input;b++){
			ranNum = Math.floor(Math.random()*colour);

			tableOut+="<td id='td_"+b+"_"+a+"'><div class='colour_"+ranNum+"' style='background:"+colours[ranNum]+"' title='' id='ball_"+b+"_"+a+"' onclick='takeColour("+b+","+a+","+ranNum+");checkAround("+b+","+a+");'></div></td>";
		}
		tableOut+="</tr>";
	}
	tableOut+="</table>";
	document.getElementById("output").innerHTML = tableOut;
}

function clearBg(){
	for(a=0;a<input;a++){
		for(b=0;b<input;b++){
			document.getElementById("td_"+b+"_"+a).style.backgroundColor="white";
		}
	}
}

function takeColour(x,y,originalColour){
	if(document.getElementById("td_"+x+"_"+y).style.backgroundColor=="yellow"){
		removeBalls();
	}
	clearBg();
	colourToFind = originalColour;
	ballCount=0;
}

function checkAround(x,y){
	if(x>=input||x<0||y>=input||y<0||document.getElementById("td_"+x+"_"+y).style.backgroundColor=="yellow"){
		return 0;
	}
	else{
		if(document.getElementById("ball_"+x+"_"+y)!=null){
			ballClass = document.getElementById("ball_"+x+"_"+y).className;
			ballColour = ballClass.split("colour_");
		}
		else{
			return 0;	
		}
		if(ballColour[1]==colourToFind){
			ballCount++;
			document.getElementById("td_"+x+"_"+y).style.backgroundColor="yellow";
			//check everywhere
			checkAround(x+1,y);
			checkAround(x,y+1);
			checkAround(x-1,y);
			checkAround(x,y-1);
		}
		else{
			return 0;	
		}
	}	
}

function removeBalls(){
	if(ballCount!=1){
		score+=ballCount;
		document.getElementById("score").innerHTML = "Score: "+score;
		for(a=0;a<input;a++){
			for(b=0;b<input;b++){
				if(document.getElementById("td_"+b+"_"+a).style.backgroundColor=="yellow"){
					element = document.getElementById("ball_"+b+"_"+a);
					element.parentNode.removeChild(element);
				}
			}
		}
	}
	gravity();
}

function gravity(){
	if(ballCount!=1){
		//downward gravity
		for(abc=0;abc<=input;abc++){
			for(a=(input-1);a>=0;a--){
				for(b=(input-1);b>=0;b--){
					if(document.getElementById("ball_"+b+"_"+a)==null){//if empty
						if(document.getElementById("ball_"+b+"_"+parseInt(a-1))!=null){ //something above
							elementz = document.getElementById("ball_"+b+"_"+parseInt(a-1));
							replaceBalls(elementz);
						}
					}
				}
			}
		}
		
		//sideways gravity
		for(abc=0;abc<=input;abc++){
			for(a=(input-1);a>=0;a--){
				for(b=(input-1);b>=0;b--){
					if(document.getElementById("ball_"+b+"_"+a)==null){//if empty
						if(document.getElementById("ball_"+parseInt(b-1)+"_"+a)!=null){ //something above
							elementz = document.getElementById("ball_"+parseInt(b-1)+"_"+a);
							replaceBalls(elementz);
						}
					}
				}
			}
		}
	}
	checkBoard();
}

function replaceBalls(element){
	oldBallClass = element.className;
	oldBallColour = oldBallClass.split("colour_");
	element.parentNode.removeChild(element);
	document.getElementById("td_"+b+"_"+a).innerHTML="<div class='colour_"+oldBallColour[1]+"' style='background:"+colours[					oldBallColour[1]]+"' id='ball_"+b+"_"+a+"' onclick='takeColour("+b+","+a+","+oldBallColour[1]+");checkAround("+b+","+a+");'></div>";	
}

function checkBoard(){
	for(a=(input-1);a>0;a--){
		for(b=(input-1);b>0;b--){
			if(document.getElementById("ball_"+b+"_"+a)!=null){//if not empty
				elementzz = document.getElementById("ball_"+b+"_"+a);
				checkBallClass = elementzz.className;
				checkBallColour = checkBallClass.split("colour_");
				
				zelementz = document.getElementById("ball_"+parseInt(b+1)+"_"+a)
				if(zelementz!=null){ //something above
					eleBallClass = zelementz.className;
					eleBallColour = eleBallClass.split("colour_");
					if(eleBallColour[1]==checkBallColour[1]){
						return;
					}
				}
				
				zelementz = document.getElementById("ball_"+parseInt(b-1)+"_"+a)
				if(zelementz!=null){ //something above
					eleBallClass = zelementz.className;
					eleBallColour = eleBallClass.split("colour_");
					if(eleBallColour[1]==checkBallColour[1]){
						return;
					}
				}
				
				zelementz = document.getElementById("ball_"+b+"_"+parseInt(a+1))
				if(zelementz!=null){ //something above
					eleBallClass = zelementz.className;
					eleBallColour = eleBallClass.split("colour_");
					if(eleBallColour[1]==checkBallColour[1]){
						return;
					}
				}
				
				zelementz = document.getElementById("ball_"+b+"_"+parseInt(a-1))
				if(zelementz!=null){ //something above
					eleBallClass = zelementz.className;
					eleBallColour = eleBallClass.split("colour_");
					if(eleBallColour[1]==checkBallColour[1]){
						return;
					}
				}
				
			}
		}
	}
	
	clearBg();
	
	
	if(score == Math.pow(input,2)){
		alert("WOW! YOU HAVE CLEARED THE ENTIRE BOARD!\nWELL DONE!");
	}
	else{
		alert("GAME OVER! Your score is: "+score);
	}
	
	Start();
}
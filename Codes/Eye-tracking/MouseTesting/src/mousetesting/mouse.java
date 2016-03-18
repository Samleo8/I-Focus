package mousetesting;

import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.MouseInfo;
import java.io.*;

public class mouse {
    public static void move(int x,int y){
        try {
 
            Robot robot = new Robot();
            robot.mouseMove(x, y);
 
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void click(){
        try {
            click("left");
        }
        catch (Exception e) {
            e.printStackTrace();
        }    
    }
    
    public static void click(String clickType){
        try {
            Robot robot = new Robot();
            
            clickType = clickType.toLowerCase();
            
            if(clickType.equals("left")){
                robot.mousePress(InputEvent.BUTTON1_MASK);
                robot.mouseRelease(InputEvent.BUTTON1_MASK);
            }
            else if(clickType.equals("middle")){
                robot.mousePress(InputEvent.BUTTON3_MASK);
                robot.mouseRelease(InputEvent.BUTTON3_MASK);
            }
            else if(clickType.equals("right")){
                robot.mousePress(InputEvent.BUTTON2_MASK);
                //robot.mouseRelease(InputEvent.BUTTON2_MASK);
            }        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void scroll(String dir){
        try {
            int pix = 10;
            scroll(dir,pix);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void scroll(String dir, int pix){
        try {
            Robot robot = new Robot();
            if(dir.equals("up")){
                robot.mouseWheel(pix*-1);
            }
            else if(dir.equals("down")){
                robot.mouseWheel(pix);
            }
            else{
                console.log("Invalid Direction.");
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static int getX(){
        return (int)MouseInfo.getPointerInfo().getLocation().getX();
    }
    
    public static int getY(){
        return (int)MouseInfo.getPointerInfo().getLocation().getY();
    }
}

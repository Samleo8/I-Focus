package mousetesting;

import java.awt.event.KeyEvent;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jdesktop.application.Action;
import org.jdesktop.application.Application;
import org.jdesktop.application.SingleFrameApplication;

import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyListener;
import java.io.*;
import java.lang.*;
import javax.swing.JPanel;

/**
 * The main class of the application.
 */
public class MouseTestingApp extends SingleFrameApplication {
    public static boolean consoleInput = true;
    public static boolean appRunning = true;
    
    /**
     * At startup create and show the main frame of the application.
     */
    @Override protected void startup() {
        show(new MouseTestingView(this));
    }

    /**
     * This method is to initialize the specified window by injecting resources.
     * Windows shown in our application come fully initialized from the GUI
     * builder, so this additional configuration is not needed.
     */
    @Override protected void configureWindow(java.awt.Window root) {
    }

    /**
     * A convenient static getter for the application instance.
     * @return the instance of MouseTestingApp
     */
    public static MouseTestingApp getApplication() {
        return Application.getInstance(MouseTestingApp.class);
    }

    /**
     * Main method launching the application.
     */
    public static void main(String[] args) {
        //init
        launch(MouseTestingApp.class, args);        
        
        while(appRunning){
            if(consoleInput){
                console.log("Welcome to the mouse control application");
                console.log("Type HELP to see the list of conmmands");
                console.log("-----------------------------------------");

                while(consoleInput){
                    //Console Input
                    try {
                        int mx = 0;
                        int my = 0;

                        String mouseCoordIn = console.read().toLowerCase();

                        if(mouseCoordIn.equals("exit")){
                            exitApp();
                            break;
                        }
                        else if(mouseCoordIn.equals("help")){
                            //console.clear();
                            console.log("---------------------------------");
                            console.log("COMMANDS (case insensitive): ");
                            console.log("HELP: Opens this menu");
                            console.log("CLICK <type>: Simulates mouse click. Type can be left, right or middle");
                            console.log("x y: Moves mouse to coordinates x and y");
                            console.log("EXIT: Exits program");
                            console.log("---------------------------------");
                            continue;
                        }
                        else if(mouseCoordIn.equals("clear")){
                            console.clear();
                            continue;
                        }
                        else if(mouseCoordIn.contains("click")){
                            String[] mouseCoord = mouseCoordIn.split(" ");
                            if(mouseCoord.length == 1){
                                mouse.click();
                            }
                            else{
                                mouse.click(mouseCoord[1]);
                            }
                        }
                        else if(mouseCoordIn.contains("scroll")){
                            String[] mouseCoord = mouseCoordIn.split(" ");
                            if(mouseCoord.length == 1){
                                mouse.scroll("up");
                            }
                            else if(mouseCoord.length == 2){
                                mouse.scroll(mouseCoord[1]);
                            }
                            else if(mouseCoord.length == 3){
                                mouse.scroll(mouseCoord[1],Integer.parseInt(mouseCoord[2]));
                            }
                        }
                        else{
                            try{
                                //console.clear();
                                String[] mouseCoord = mouseCoordIn.split(" ");

                                mx = Math.min(Math.max(Integer.parseInt(mouseCoord[0]),0),getScreenWidth());
                                my = Math.min(Math.max(Integer.parseInt(mouseCoord[1]),0),getScreenHeight());

                                mouse.move(mx, my);
                            }
                             catch (Throwable t){
                                console.log("ERROR: Command not found");
                                console.log("Type HELP to see all commands.");
                                continue;
                            }
                        }

                    } catch (Throwable t) {
                        console.log("ERROR: Exiting Application");
                        
                        //return;
                        //Logger.getLogger(MouseTestingApp.class.getName()).log(Level.SEVERE, null, ex);
                    }   
                }
            }
            else{
                //Interface control               
                
            }
        }
    }
    
    public static int getScreenWidth() {
        return java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getMaximumWindowBounds().width;
    }

    public static int getScreenHeight() {
        return java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getMaximumWindowBounds().height;
    }
    
    public static void exitApp(){
        console.clear();
        System.exit(0);
    }
}




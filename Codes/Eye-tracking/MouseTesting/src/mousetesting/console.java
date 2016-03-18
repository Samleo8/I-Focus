package mousetesting;

import java.awt.Robot;
import java.io.*;
import java.lang.*;
import java.util.Scanner;


public class console {
    public static void log(){
        log("");
    }
    
    public static void log(String str){
        System.out.println(str);
    }
    
    
    public static String read(){
        try {
            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
            log("\n");
            return in.readLine();
        }
        catch (Throwable t) {
            log("ERROR: Cannot read from console...");
            //Logger.getLogger(console.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        }
    }
    
    public static void clear(){
        /*
        try {
            Robot r = new Robot();
            String os = System.getProperty("os.name");
            
            if(os.startsWith("Mac")){
                r.keyPress(157); // Holds Command key.
                r.keyPress(76); // Holds L key.
                r.keyRelease(157); // Releases Commands key.
                r.keyRelease(76); // Releases L key.
            }
            else{
                r.keyPress(17); // Holds CTRL key.
                r.keyPress(76); // Holds L key.
                r.keyRelease(17); // Releases CTRL key.
                r.keyRelease(76); // Releases L key.
            }
        }
        catch (Throwable t) {
            log("Problem clearing console. Press control-L manually to clear.");
        }
        //*/
    }
}

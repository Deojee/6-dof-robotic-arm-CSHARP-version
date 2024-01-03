using Godot;
using System;
using System.IO.Ports;
using System.Text;

public partial class serialCommunicator : Node
{

    //"/dev/cu.usbmodem1101"

    public override void _Ready()
    {
        serialPort = new SerialPort();
        serialPort.PortName = "/dev/cu.usbmodem11101";
        serialPort.BaudRate = 38400;

        serialPort.WriteTimeout = 1000;
        serialPort.ReadTimeout = 5000;

        tryToOpen();
    }

    private void tryToOpen()
    {
        try
        {
            serialPort.Open();
        }
        catch (Exception ex)
        {
            GD.Print("failed to open");
            GD.Print(ex);
        }
    }

    /*
    public serialCommunicator()
    {


        //return;
        
    }

    

    public serialCommunicator(string portName = "/dev/cu.usbmodem1101", int BaudRate = 9600)
    {
       

        serialPort = new SerialPort();
        serialPort.PortName = portName;
        serialPort.BaudRate = BaudRate;

        tryToOpen();
    }*/

    SerialPort serialPort;

    /***
     * message: what you want to send over serial
     * returns: false if the port is not open, otherwise true
     */
    public bool Write(String message)
    {
        
        if (!serialPort.IsOpen){
            tryToOpen();
            return false;
        }

        try
        {
            ulong time = Time.GetTicksMsec();
            serialPort.Write(message);
            //serialPort.Write(Encoding.UTF8.GetBytes(message),0,1);

            GD.Print("time it took to write: ", (Time.GetTicksMsec() - time));

        }
        catch (Exception ex)
        {
            return false;
        }
        

        return true;
    }


    /**
     * returns: the most recent message
     * 
     */
    public string Read()
    {
        
        if (!serialPort.IsOpen){
            tryToOpen();
            return "Serial port is not open.";
        }

        try {
            return serialPort.ReadLine();
        } catch (Exception ex)
        {
            return "timed out";
        }
        
    }

}

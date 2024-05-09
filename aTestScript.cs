using Godot;
using System;
using System.IO.Ports;

public partial class aTestScript : Node2D
{

	SerialPort serialPort;

	public float AVariableThatIHave = 6.6f;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

		

		GD.Print("hello");

		serialPort = new SerialPort();
		serialPort.PortName = "COM4";
		serialPort.BaudRate = 38400;
		serialPort.Open();

	}

	double lastWriteTime = 1000;

	int nextWriteNum = 1;

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{

		//GD.Print("hey");

		//

		
		if (Time.GetTicksMsec() > lastWriteTime + 2000)
		{

            GD.Print("oh no");
			lastWriteTime = Time.GetTicksMsec();

            if (!serialPort.IsOpen)
			{
				GD.Print("not connected");
			} else
			{
				GD.Print("connected!");
                serialPort.Write(nextWriteNum.ToString());

				if (nextWriteNum == 1)
				{
					nextWriteNum = 2;
				} else nextWriteNum = 1;

            }

            /*
            string serialMessage = serialPort.ReadLine();

            GD.Print(serialMessage);

			

            serialPort.Write("1");*/
        }
		


	}
}

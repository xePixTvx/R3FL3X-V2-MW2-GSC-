using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;


//Simple C# Dll Injector
//Dll Injector by xePixTvx
//Mw2 Mod Loader By AgentGOD
//Pls Give Credits
namespace R3FL3X_INJECTOR
{
    public partial class Form1 : Form
    {
        #region MOTD SETUP
        int MotdXPos;
        int MotdNumb;
        List<string> MOTDS = new List<string>();
        #endregion

        String strProcessNamee = "NONE";

        public Form1()
        {
            InitializeComponent();
            setUpMOTD();
            //inject_button.Enabled = false;
        }

        private void UpdateProcessList()
        {
            Process[] processlist = Process.GetProcesses();
            processList.Items.Clear();
            recProcList.Items.Clear();
            foreach (Process bitch in processlist)
            {
                processList.Items.Add(bitch.ProcessName);
                if (bitch.ProcessName.Contains("iw") || bitch.ProcessName.Contains("mw") || bitch.ProcessName.Contains("cod"))
                {
                    recProcList.Items.Add(bitch.ProcessName);
                }
            }
        }

        #region MOTD
        private void setUpMOTD()
        {
            MOTDS.Clear();
            MOTDS.Add("Welcome " + Environment.UserName);
            MOTDS.Add("R3FL3X V2 Mw2 GSC Mod Menu");
            MOTDS.Add("Created By xePixTvx");
            MOTDS.Add("www.CabConModding.com");

            MotdNumb = 0;
            MotdXPos = 800;
            MOTD_LABEL.Location = new Point(MotdXPos, 370);
            MOTD_LABEL.Text = MOTDS[MotdNumb];
        }
        private void Motd_Timer_Tick(object sender, EventArgs e)
        {
            MotdXPos -= 1;
            MOTD_LABEL.Location = new Point(MotdXPos, 370);
            if (MOTD_LABEL.Location.X == -200)
            {
                MotdXPos = 800;
                MOTD_LABEL.Location = new Point(MotdXPos, 370);
                MotdNumb++;
                if (MotdNumb > MOTDS.Count - 1)
                {
                    MotdNumb = 0;
                }
                MOTD_LABEL.Text = MOTDS[MotdNumb];
            }
        }
        #endregion

        #region Injection_Stuff
        [DllImport("kernel32")]
        public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, UIntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, out IntPtr lpThreadId);
        [DllImport("kernel32.dll")]
        public static extern IntPtr OpenProcess(UInt32 dwDesiredAccess, Int32 bInheritHandle, Int32 dwProcessId);
        [DllImport("kernel32.dll")]
        public static extern Int32 CloseHandle(IntPtr hObject);
        [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
        static extern bool VirtualFreeEx(IntPtr hProcess, IntPtr lpAddress, UIntPtr dwSize, uint dwFreeType);
        [DllImport("kernel32.dll", CharSet = CharSet.Ansi, ExactSpelling = true)]
        public static extern UIntPtr GetProcAddress(IntPtr hModule, string procName);
        [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
        static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
        [DllImport("kernel32.dll")]
        static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, string lpBuffer, UIntPtr nSize, out IntPtr lpNumberOfBytesWritten);
        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr GetModuleHandle(string lpModuleName);
        [DllImport("kernel32", SetLastError = true, ExactSpelling = true)]
        internal static extern Int32 WaitForSingleObject(IntPtr handle, Int32 milliseconds);

        public Int32 GetProcessId(String proc)
        {
            Process[] ProcList;
            ProcList = Process.GetProcessesByName(proc);
            return ProcList[0].Id;
        }

        public void InjectDLL(IntPtr hProcess, String strDLLName)
        {
            IntPtr bytesout;
            Int32 LenWrite = strDLLName.Length + 1;
            IntPtr AllocMem = (IntPtr)VirtualAllocEx(hProcess, (IntPtr)null, (uint)LenWrite, 0x1000, 0x40);
            WriteProcessMemory(hProcess, AllocMem, strDLLName, (UIntPtr)LenWrite, out bytesout);
            UIntPtr Injector = (UIntPtr)GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryA");
            if (Injector == null)
            {
                MessageBox.Show(" Injector Error! \n ");
                return;
            }
            IntPtr hThread = (IntPtr)CreateRemoteThread(hProcess, (IntPtr)null, 0, Injector, AllocMem, 0, out bytesout);
            if (hThread == null)
            {
                MessageBox.Show(" hThread [ 1 ] Error! \n ");
                return;
            }
            int Result = WaitForSingleObject(hThread, 10 * 1000);
            if (Result == 0x00000080L || Result == 0x00000102L || Result == 0xFFFFFFFF)
            {
                MessageBox.Show(" hThread [ 2 ] Error! \n ");
                if (hThread != null)
                {
                    CloseHandle(hThread);
                }
                return;
            }
            Thread.Sleep(1000);
            VirtualFreeEx(hProcess, AllocMem, (UIntPtr)0, 0x8000);
            if (hThread != null)
            {
                CloseHandle(hThread);
            }
            MessageBox.Show("Injected <3", "YAY!", MessageBoxButtons.OK);
            return;
        }
        #endregion

        #region List Shit
        private void processList_SelectedIndexChanged(object sender, EventArgs e)
        {
            for (int i = 0; i < processList.Items.Count; i++ )
            {
                processList.SetItemChecked(i, false);
            }
            for (int i = 0; i < recProcList.Items.Count; i++)
            {
                recProcList.SetItemChecked(i, false);
            }
            strProcessNamee = processList.SelectedItem.ToString();
        }
        private void recProcList_SelectedIndexChanged(object sender, EventArgs e)
        {
            for (int i = 0; i < processList.Items.Count; i++)
            {
                processList.SetItemChecked(i, false);
            }
            for (int i = 0; i < recProcList.Items.Count; i++)
            {
                recProcList.SetItemChecked(i, false);
            }
            strProcessNamee = recProcList.SelectedItem.ToString();
        }
        #endregion

        private void updateProcessButton_Click(object sender, EventArgs e)
        {
            UpdateProcessList();
        }

        private void inject_button_Click(object sender, EventArgs e)
        {
            if (strProcessNamee=="NONE")
            {
                strProcessNamee = "NONE";
                MessageBox.Show("ERROR WAAATTT!!!!");
                return;
            }
            String strProcessName = strProcessNamee;
            String strDLLName = Path.Combine(Environment.CurrentDirectory, @"data\", "MW2_Modder.dll");
            if (!File.Exists(strDLLName))
            {
                MessageBox.Show("Files Not Found!");
            }
            Int32 ProcID = GetProcessId(strProcessName);
            if (ProcID >= 0)
            {
                IntPtr hProcess = (IntPtr)OpenProcess(0x1F0FFF, 1, ProcID);
                if (hProcess == null)
                {
                    MessageBox.Show("OpenProcess() Failed!");
                    return;
                }
                else
                {
                    InjectDLL(hProcess, strDLLName);
                }
            }
        }




    }
}

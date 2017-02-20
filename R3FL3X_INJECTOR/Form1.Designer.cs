namespace R3FL3X_INJECTOR
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.huraForm1 = new Hura_Theme.HuraForm();
            this.processList = new System.Windows.Forms.CheckedListBox();
            this.MOTD_LABEL = new System.Windows.Forms.Label();
            this.huraControlBox1 = new Hura_Theme.HuraControlBox();
            this.shapeContainer1 = new Microsoft.VisualBasic.PowerPacks.ShapeContainer();
            this.rectangleShape1 = new Microsoft.VisualBasic.PowerPacks.RectangleShape();
            this.Motd_Timer = new System.Windows.Forms.Timer(this.components);
            this.logInGroupBox1 = new Login_Theme.LogInGroupBox();
            this.logInGroupBox2 = new Login_Theme.LogInGroupBox();
            this.recProcList = new System.Windows.Forms.CheckedListBox();
            this.inject_button = new Hura_Theme.HuraButton();
            this.updateProcessButton = new Hura_Theme.HuraButton();
            this.huraForm1.SuspendLayout();
            this.logInGroupBox1.SuspendLayout();
            this.logInGroupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // huraForm1
            // 
            this.huraForm1.AccentColor = System.Drawing.Color.FromArgb(((int)(((byte)(90)))), ((int)(((byte)(90)))), ((int)(((byte)(90)))));
            this.huraForm1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(40)))), ((int)(((byte)(40)))));
            this.huraForm1.ColorScheme = Hura_Theme.HuraForm.ColorSchemes.Dark;
            this.huraForm1.Controls.Add(this.updateProcessButton);
            this.huraForm1.Controls.Add(this.inject_button);
            this.huraForm1.Controls.Add(this.logInGroupBox2);
            this.huraForm1.Controls.Add(this.logInGroupBox1);
            this.huraForm1.Controls.Add(this.MOTD_LABEL);
            this.huraForm1.Controls.Add(this.huraControlBox1);
            this.huraForm1.Controls.Add(this.shapeContainer1);
            this.huraForm1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.huraForm1.Font = new System.Drawing.Font("Segoe UI", 9.5F);
            this.huraForm1.ForeColor = System.Drawing.Color.White;
            this.huraForm1.Location = new System.Drawing.Point(0, 0);
            this.huraForm1.MaximumSize = new System.Drawing.Size(654, 550);
            this.huraForm1.Name = "huraForm1";
            this.huraForm1.Size = new System.Drawing.Size(654, 405);
            this.huraForm1.TabIndex = 0;
            this.huraForm1.Text = "R3FL3X V2 Injector for Pc";
            // 
            // processList
            // 
            this.processList.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(50)))), ((int)(((byte)(50)))), ((int)(((byte)(50)))));
            this.processList.CheckOnClick = true;
            this.processList.ForeColor = System.Drawing.Color.White;
            this.processList.FormattingEnabled = true;
            this.processList.Location = new System.Drawing.Point(9, 36);
            this.processList.Name = "processList";
            this.processList.Size = new System.Drawing.Size(261, 184);
            this.processList.Sorted = true;
            this.processList.TabIndex = 3;
            this.processList.SelectedIndexChanged += new System.EventHandler(this.processList_SelectedIndexChanged);
            // 
            // MOTD_LABEL
            // 
            this.MOTD_LABEL.AutoSize = true;
            this.MOTD_LABEL.Font = new System.Drawing.Font("Impact", 12F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.MOTD_LABEL.Location = new System.Drawing.Point(800, 370);
            this.MOTD_LABEL.Margin = new System.Windows.Forms.Padding(10);
            this.MOTD_LABEL.Name = "MOTD_LABEL";
            this.MOTD_LABEL.Size = new System.Drawing.Size(76, 20);
            this.MOTD_LABEL.TabIndex = 2;
            this.MOTD_LABEL.Text = "Test MOTD";
            // 
            // huraControlBox1
            // 
            this.huraControlBox1.AccentColor = System.Drawing.Color.FromArgb(((int)(((byte)(60)))), ((int)(((byte)(60)))), ((int)(((byte)(60)))));
            this.huraControlBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.huraControlBox1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(40)))), ((int)(((byte)(40)))));
            this.huraControlBox1.ColorScheme = Hura_Theme.HuraControlBox.ColorSchemes.Dark;
            this.huraControlBox1.ForeColor = System.Drawing.Color.White;
            this.huraControlBox1.Location = new System.Drawing.Point(551, 3);
            this.huraControlBox1.Name = "huraControlBox1";
            this.huraControlBox1.Size = new System.Drawing.Size(100, 25);
            this.huraControlBox1.TabIndex = 0;
            this.huraControlBox1.Text = "huraControlBox1";
            // 
            // shapeContainer1
            // 
            this.shapeContainer1.Location = new System.Drawing.Point(0, 0);
            this.shapeContainer1.Margin = new System.Windows.Forms.Padding(0);
            this.shapeContainer1.Name = "shapeContainer1";
            this.shapeContainer1.Shapes.AddRange(new Microsoft.VisualBasic.PowerPacks.Shape[] {
            this.rectangleShape1});
            this.shapeContainer1.Size = new System.Drawing.Size(654, 405);
            this.shapeContainer1.TabIndex = 1;
            this.shapeContainer1.TabStop = false;
            // 
            // rectangleShape1
            // 
            this.rectangleShape1.BorderColor = System.Drawing.SystemColors.ButtonFace;
            this.rectangleShape1.BorderWidth = 2;
            this.rectangleShape1.Location = new System.Drawing.Point(-2, 361);
            this.rectangleShape1.Name = "rectangleShape1";
            this.rectangleShape1.SelectionColor = System.Drawing.Color.Transparent;
            this.rectangleShape1.Size = new System.Drawing.Size(659, 36);
            // 
            // Motd_Timer
            // 
            this.Motd_Timer.Enabled = true;
            this.Motd_Timer.Interval = 1;
            this.Motd_Timer.Tick += new System.EventHandler(this.Motd_Timer_Tick);
            // 
            // logInGroupBox1
            // 
            this.logInGroupBox1.BorderColour = System.Drawing.Color.FromArgb(((int)(((byte)(35)))), ((int)(((byte)(35)))), ((int)(((byte)(35)))));
            this.logInGroupBox1.Controls.Add(this.processList);
            this.logInGroupBox1.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
            this.logInGroupBox1.HeaderColour = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.logInGroupBox1.Location = new System.Drawing.Point(3, 38);
            this.logInGroupBox1.MainColour = System.Drawing.Color.FromArgb(((int)(((byte)(47)))), ((int)(((byte)(47)))), ((int)(((byte)(47)))));
            this.logInGroupBox1.Name = "logInGroupBox1";
            this.logInGroupBox1.Size = new System.Drawing.Size(280, 234);
            this.logInGroupBox1.TabIndex = 4;
            this.logInGroupBox1.Text = "Process List";
            this.logInGroupBox1.TextColour = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            // 
            // logInGroupBox2
            // 
            this.logInGroupBox2.BorderColour = System.Drawing.Color.FromArgb(((int)(((byte)(35)))), ((int)(((byte)(35)))), ((int)(((byte)(35)))));
            this.logInGroupBox2.Controls.Add(this.recProcList);
            this.logInGroupBox2.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
            this.logInGroupBox2.HeaderColour = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.logInGroupBox2.Location = new System.Drawing.Point(362, 38);
            this.logInGroupBox2.MainColour = System.Drawing.Color.FromArgb(((int)(((byte)(47)))), ((int)(((byte)(47)))), ((int)(((byte)(47)))));
            this.logInGroupBox2.Name = "logInGroupBox2";
            this.logInGroupBox2.Size = new System.Drawing.Size(280, 234);
            this.logInGroupBox2.TabIndex = 5;
            this.logInGroupBox2.Text = "Recommended Processes";
            this.logInGroupBox2.TextColour = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            // 
            // recProcList
            // 
            this.recProcList.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(50)))), ((int)(((byte)(50)))), ((int)(((byte)(50)))));
            this.recProcList.CheckOnClick = true;
            this.recProcList.ForeColor = System.Drawing.Color.White;
            this.recProcList.FormattingEnabled = true;
            this.recProcList.Location = new System.Drawing.Point(9, 36);
            this.recProcList.Name = "recProcList";
            this.recProcList.Size = new System.Drawing.Size(261, 184);
            this.recProcList.Sorted = true;
            this.recProcList.TabIndex = 3;
            this.recProcList.SelectedIndexChanged += new System.EventHandler(this.recProcList_SelectedIndexChanged);
            // 
            // inject_button
            // 
            this.inject_button.AccentColor = System.Drawing.Color.FromArgb(((int)(((byte)(70)))), ((int)(((byte)(70)))), ((int)(((byte)(70)))));
            this.inject_button.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(50)))), ((int)(((byte)(50)))), ((int)(((byte)(50)))));
            this.inject_button.ColorScheme = Hura_Theme.HuraButton.ColorSchemes.Dark;
            this.inject_button.Font = new System.Drawing.Font("Segoe UI", 9.5F);
            this.inject_button.ForeColor = System.Drawing.Color.White;
            this.inject_button.Location = new System.Drawing.Point(12, 297);
            this.inject_button.Name = "inject_button";
            this.inject_button.Size = new System.Drawing.Size(223, 38);
            this.inject_button.TabIndex = 6;
            this.inject_button.Text = "Inject";
            this.inject_button.UseVisualStyleBackColor = false;
            this.inject_button.Click += new System.EventHandler(this.inject_button_Click);
            // 
            // updateProcessButton
            // 
            this.updateProcessButton.AccentColor = System.Drawing.Color.FromArgb(((int)(((byte)(70)))), ((int)(((byte)(70)))), ((int)(((byte)(70)))));
            this.updateProcessButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(50)))), ((int)(((byte)(50)))), ((int)(((byte)(50)))));
            this.updateProcessButton.ColorScheme = Hura_Theme.HuraButton.ColorSchemes.Dark;
            this.updateProcessButton.Font = new System.Drawing.Font("Segoe UI", 9.5F);
            this.updateProcessButton.ForeColor = System.Drawing.Color.White;
            this.updateProcessButton.Location = new System.Drawing.Point(419, 297);
            this.updateProcessButton.Name = "updateProcessButton";
            this.updateProcessButton.Size = new System.Drawing.Size(223, 38);
            this.updateProcessButton.TabIndex = 7;
            this.updateProcessButton.Text = "Update Processes";
            this.updateProcessButton.UseVisualStyleBackColor = false;
            this.updateProcessButton.Click += new System.EventHandler(this.updateProcessButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(654, 405);
            this.Controls.Add(this.huraForm1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Form1";
            this.huraForm1.ResumeLayout(false);
            this.huraForm1.PerformLayout();
            this.logInGroupBox1.ResumeLayout(false);
            this.logInGroupBox2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private Hura_Theme.HuraForm huraForm1;
        private Hura_Theme.HuraControlBox huraControlBox1;
        private Microsoft.VisualBasic.PowerPacks.ShapeContainer shapeContainer1;
        private Microsoft.VisualBasic.PowerPacks.RectangleShape rectangleShape1;
        private System.Windows.Forms.Label MOTD_LABEL;
        private System.Windows.Forms.Timer Motd_Timer;
        private System.Windows.Forms.CheckedListBox processList;
        private Login_Theme.LogInGroupBox logInGroupBox1;
        private Login_Theme.LogInGroupBox logInGroupBox2;
        private System.Windows.Forms.CheckedListBox recProcList;
        private Hura_Theme.HuraButton updateProcessButton;
        private Hura_Theme.HuraButton inject_button;
    }
}


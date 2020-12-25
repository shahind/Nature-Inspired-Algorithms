namespace AnglerfishAlgorithm
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
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.rbEUCL = new System.Windows.Forms.RadioButton();
            this.rbGEO = new System.Windows.Forms.RadioButton();
            this.btnStop = new System.Windows.Forms.Button();
            this.txtReductionNumber = new System.Windows.Forms.TextBox();
            this.txtSpawnNumber = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnRun = new System.Windows.Forms.Button();
            this.txtTimeCycle = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.listEvent = new System.Windows.Forms.ListBox();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbEUCL);
            this.groupBox1.Controls.Add(this.rbGEO);
            this.groupBox1.Controls.Add(this.btnStop);
            this.groupBox1.Controls.Add(this.txtReductionNumber);
            this.groupBox1.Controls.Add(this.txtSpawnNumber);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.btnRun);
            this.groupBox1.Controls.Add(this.txtTimeCycle);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(16, 15);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(4);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(4);
            this.groupBox1.Size = new System.Drawing.Size(467, 120);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            // 
            // rbEUCL
            // 
            this.rbEUCL.AutoSize = true;
            this.rbEUCL.Location = new System.Drawing.Point(324, 19);
            this.rbEUCL.Name = "rbEUCL";
            this.rbEUCL.Size = new System.Drawing.Size(84, 21);
            this.rbEUCL.TabIndex = 9;
            this.rbEUCL.Text = "EUCL 2D";
            this.rbEUCL.UseVisualStyleBackColor = true;
            // 
            // rbGEO
            // 
            this.rbGEO.AutoSize = true;
            this.rbGEO.Checked = true;
            this.rbGEO.Location = new System.Drawing.Point(249, 19);
            this.rbGEO.Name = "rbGEO";
            this.rbGEO.Size = new System.Drawing.Size(57, 21);
            this.rbGEO.TabIndex = 8;
            this.rbGEO.TabStop = true;
            this.rbGEO.Text = "GEO";
            this.rbGEO.UseVisualStyleBackColor = true;
            // 
            // btnStop
            // 
            this.btnStop.Location = new System.Drawing.Point(343, 67);
            this.btnStop.Name = "btnStop";
            this.btnStop.Size = new System.Drawing.Size(75, 39);
            this.btnStop.TabIndex = 7;
            this.btnStop.Text = "Stop";
            this.btnStop.UseVisualStyleBackColor = true;
            this.btnStop.Click += new System.EventHandler(this.btnStop_Click);
            // 
            // txtReductionNumber
            // 
            this.txtReductionNumber.Location = new System.Drawing.Point(156, 83);
            this.txtReductionNumber.Name = "txtReductionNumber";
            this.txtReductionNumber.Size = new System.Drawing.Size(74, 23);
            this.txtReductionNumber.TabIndex = 6;
            this.txtReductionNumber.Text = "50";
            // 
            // txtSpawnNumber
            // 
            this.txtSpawnNumber.Location = new System.Drawing.Point(156, 51);
            this.txtSpawnNumber.Name = "txtSpawnNumber";
            this.txtSpawnNumber.Size = new System.Drawing.Size(74, 23);
            this.txtSpawnNumber.TabIndex = 5;
            this.txtSpawnNumber.Text = "700";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(9, 89);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(143, 17);
            this.label3.TabIndex = 4;
            this.label3.Text = "Reduction Number, r:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(21, 54);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(131, 17);
            this.label2.TabIndex = 3;
            this.label2.Text = "Spawn Number, sp:";
            // 
            // btnRun
            // 
            this.btnRun.Location = new System.Drawing.Point(249, 67);
            this.btnRun.Name = "btnRun";
            this.btnRun.Size = new System.Drawing.Size(75, 39);
            this.btnRun.TabIndex = 2;
            this.btnRun.Text = "Run";
            this.btnRun.UseVisualStyleBackColor = true;
            this.btnRun.Click += new System.EventHandler(this.btnRun_Click);
            // 
            // txtTimeCycle
            // 
            this.txtTimeCycle.Location = new System.Drawing.Point(156, 17);
            this.txtTimeCycle.Name = "txtTimeCycle";
            this.txtTimeCycle.Size = new System.Drawing.Size(74, 23);
            this.txtTimeCycle.TabIndex = 1;
            this.txtTimeCycle.Text = "100";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(73, 23);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(79, 17);
            this.label1.TabIndex = 0;
            this.label1.Text = "Time cycle:";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.listEvent);
            this.groupBox2.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.groupBox2.Location = new System.Drawing.Point(0, 142);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(497, 462);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            // 
            // listEvent
            // 
            this.listEvent.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listEvent.FormattingEnabled = true;
            this.listEvent.ItemHeight = 16;
            this.listEvent.Location = new System.Drawing.Point(3, 19);
            this.listEvent.Name = "listEvent";
            this.listEvent.Size = new System.Drawing.Size(491, 440);
            this.listEvent.TabIndex = 0;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(497, 604);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Anglerfish Algorithm for TSP";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btnRun;
        private System.Windows.Forms.TextBox txtTimeCycle;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.ListBox listEvent;
        private System.Windows.Forms.Button btnStop;
        private System.Windows.Forms.TextBox txtReductionNumber;
        private System.Windows.Forms.TextBox txtSpawnNumber;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.RadioButton rbEUCL;
        private System.Windows.Forms.RadioButton rbGEO;
    }
}


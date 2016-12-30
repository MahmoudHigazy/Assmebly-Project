using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Linq;
using System.Runtime.InteropServices;

namespace Image_Text_Steganography
{
    public partial class Form1 : Form
    {
        /*[DllImport("Project.dll")]
        private static extern void ReadF(string FilePath, int sz);

        [DllImport("Project.dll")]
        private static extern void HideMessage(string Message, int sz);*/

        private string OpenedFilePath;

        public Form1()
        {
            InitializeComponent();
        }

        RGBPixel[,] ImageMatrix;

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog1 = new OpenFileDialog();
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                //Open the browsed image and display it
                OpenedFilePath = openFileDialog1.FileName;
                ImageMatrix = ImageOperations.OpenImage(OpenedFilePath);
                
            }
        }

        private void button4_Click_1(object sender, EventArgs e)
        {
            ImageOperations.DisplayImage(ref ImageMatrix, pictureBox1);
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            SaveFileDialog saveFileDialog1 = new SaveFileDialog();
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                //Open the browsed image and display it
                string FilePath = saveFileDialog1.FileName;
                ImageOperations.SaveAsTxtFile(ref ImageMatrix, FilePath);
                System.Windows.Forms.MessageBox.Show("Done");
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog2 = new OpenFileDialog();
            if (openFileDialog2.ShowDialog() == DialogResult.OK)
            {
                //Open the browsed image and display it
                OpenedFilePath = openFileDialog2.FileName;
                ImageMatrix = ImageOperations.OpenTxtFile(OpenedFilePath);

            }
        }

        private void button6_Click(object sender, EventArgs e)
        {
            ImageOperations.DisplayImage(ref ImageMatrix, pictureBox2);
        }

        private void button3_Click_1(object sender, EventArgs e)
        {
            SaveFileDialog saveFileDialog2 = new SaveFileDialog();
            if (saveFileDialog2.ShowDialog() == DialogResult.OK)
            {
                //Open the browsed image and display it
                string FilePath = saveFileDialog2.FileName;
                ImageOperations.SaveAsBMP(ref ImageMatrix, FilePath);
                System.Windows.Forms.MessageBox.Show("Done");
            }
        }
    }
}

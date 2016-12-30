using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Drawing.Imaging;

namespace Image_Text_Steganography
{
    public struct RGBPixel
    {
        public byte red, green, blue;
    }

    public class ImageOperations
    {
        public static RGBPixel[,] OpenImage(string ImagePath)
        {
            Bitmap original_bm = new Bitmap(ImagePath);
            int Height = original_bm.Height;
            int Width = original_bm.Width;

            RGBPixel[,] Buffer = new RGBPixel[Height, Width];

            unsafe
            {
                BitmapData bmd = original_bm.LockBits(new Rectangle(0, 0, Width, Height), ImageLockMode.ReadWrite, original_bm.PixelFormat);
                int x, y;
                int nWidth = 0;
                bool Format32 = false;
                bool Format24 = false;
                bool Format8 = false;

                if (original_bm.PixelFormat == PixelFormat.Format24bppRgb)
                {
                    Format24 = true;
                    nWidth = Width * 3;
                }
                else if (original_bm.PixelFormat == PixelFormat.Format32bppArgb || original_bm.PixelFormat == PixelFormat.Format32bppRgb || original_bm.PixelFormat == PixelFormat.Format32bppPArgb)
                {
                    Format32 = true;
                    nWidth = Width * 4;
                }
                else if (original_bm.PixelFormat == PixelFormat.Format8bppIndexed)
                {
                    Format8 = true;
                    nWidth = Width;
                }
                int nOffset = bmd.Stride - nWidth;
                byte* p = (byte*)bmd.Scan0;
                for (y = 0; y < Height; y++)
                {
                    for (x = 0; x < Width; x++)
                    {
                        if (Format8)
                        {
                            Buffer[y, x].red = Buffer[y, x].green = Buffer[y, x].blue = p[0];
                            p++;
                        }
                        else
                        {
                            Buffer[y, x].red = p[2];
                            Buffer[y, x].green = p[1];
                            Buffer[y, x].blue = p[0];
                            if (Format24) p += 3;
                            else if (Format32) p += 4;
                        }
                    }
                    p += nOffset;
                }
                original_bm.UnlockBits(bmd);
            }

            return Buffer;
        }

        public static int GetHeight(ref RGBPixel[,] ImageMatrix)
        {
            return ImageMatrix.GetLength(0);
        }

        public static int GetWidth(ref RGBPixel[,] ImageMatrix)
        {
            return ImageMatrix.GetLength(1);
        }

        public static void DisplayImage(ref RGBPixel[,] ImageMatrix, PictureBox PicBox)
        {
            // Create Image:
            //==============
            int Height = ImageMatrix.GetLength(0);
            int Width = ImageMatrix.GetLength(1);

            Bitmap ImageBMP = new Bitmap(Width, Height, PixelFormat.Format24bppRgb);

            unsafe
            {
                BitmapData bmd = ImageBMP.LockBits(new Rectangle(0, 0, Width, Height), ImageLockMode.ReadWrite, ImageBMP.PixelFormat);
                int nWidth = 0;
                nWidth = Width * 3;
                int nOffset = bmd.Stride - nWidth;
                byte* p = (byte*)bmd.Scan0;
                for (int i = 0; i < Height; i++)
                {
                    for (int j = 0; j < Width; j++)
                    {
                        p[2] = ImageMatrix[i, j].red;
                        p[1] = ImageMatrix[i, j].green;
                        p[0] = ImageMatrix[i, j].blue;
                        p += 3;
                    }

                    p += nOffset;
                }
                ImageBMP.UnlockBits(bmd);
            }
            PicBox.Image = ImageBMP;
        }

        public static void SaveAsTxtFile(ref RGBPixel[,] ImageMatrix, string FilePath)
        {
            List<string> Lines = new List<string>();
            int N = GetHeight(ref ImageMatrix), M = GetWidth(ref ImageMatrix);
            Lines.Add(N.ToString());
            Lines.Add(M.ToString());

            for(int i = 0; i < N; i++)
            {
                for(int j=0; j < M; j++)
                {
                    Lines.Add(ImageMatrix[i, j].red.ToString());
                    Lines.Add(ImageMatrix[i, j].green.ToString());
                    Lines.Add(ImageMatrix[i, j].blue.ToString());
                }
            }
            
            System.IO.File.WriteAllLines(FilePath + ".txt", Lines);
        }

        public static RGBPixel[,] OpenTxtFile(string FilePath)
        {
            string[] lines = System.IO.File.ReadAllLines(FilePath);
            int H = Convert.ToInt32(lines[0]), W = Convert.ToInt32(lines[1]);
            RGBPixel[,] Image = new RGBPixel[H, W];

            int x = 0, y = 0;

            for(int i = 2; i < lines.Length; i += 3)
            {
                Image[x, y].red = Convert.ToByte(lines[i]);
                Image[x, y].green = Convert.ToByte(lines[i + 1]);
                Image[x, y].blue = Convert.ToByte(lines[i + 2]);
                y++;
                if(y == W)
                {
                    x++;
                    y = 0;
                }
            }

            return Image;
        }

        public static void SaveAsBMP(ref RGBPixel[,] ImageMatrix, string FilePath)
        {
            int Height = GetHeight(ref ImageMatrix);
            int Width = GetWidth(ref ImageMatrix);

            Bitmap ImageBMP = new Bitmap(Width, Height, PixelFormat.Format24bppRgb);

            unsafe
            {
                BitmapData bmd = ImageBMP.LockBits(new Rectangle(0, 0, Width, Height), ImageLockMode.ReadWrite, ImageBMP.PixelFormat);
                int nWidth = 0;
                nWidth = Width * 3;
                int nOffset = bmd.Stride - nWidth;
                byte* p = (byte*)bmd.Scan0;
                for (int i = 0; i < Height; i++)
                {
                    for (int j = 0; j < Width; j++)
                    {
                        p[2] = ImageMatrix[i, j].red;
                        p[1] = ImageMatrix[i, j].green;
                        p[0] = ImageMatrix[i, j].blue;
                        p += 3;
                    }

                    p += nOffset;
                }
                ImageBMP.UnlockBits(bmd);
            }
            ImageBMP.Save(FilePath + ".bmp", System.Drawing.Imaging.ImageFormat.Bmp);
        }


    }
}

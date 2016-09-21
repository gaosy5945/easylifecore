package com.amarsoft.app.als;


import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Hashtable;

import javax.imageio.ImageIO;

import com.amarsoft.are.ARE;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.Result;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;

public class QRUtil
{
	private static final String CODE = "utf-8";
	private static final int BLACK = 0xff000000;
	private static final int WHITE = 0xFFFFFFFF;

	/**
	 * ����RQ��ά��
	 * 
	 * 
	 * @param str
	 *            ����
	 * @param height
	 *            �߶ȣ�px��
	 * 
	 */
	public static BufferedImage getRQ(String str, Integer height)
	{
		if (height == null || height < 100)
		{
			height = 200;
		}

		try
		{
			// ���ֱ���
			Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();
			hints.put(EncodeHintType.CHARACTER_SET, CODE);

			BitMatrix bitMatrix = new MultiFormatWriter().encode(str,
					BarcodeFormat.QR_CODE, height, height, hints);

			return toBufferedImage(bitMatrix);

			// �����ʽ
			// ��ҳ
			// ImageIO.write(image, "png", response.getOutputStream());

			// �ļ�
			// ImageIO.write(image, "png", file);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * ����һά�루128��
	 * 
	 * 
	 * @param str
	 * @param width
	 * @param height
	 * @return
	 */
	public static BufferedImage getBarcode(String str, Integer width,
			Integer height)
	{

		if (width == null || width < 200)
		{
			width = 200;
		}

		if (height == null || height < 50)
		{
			height = 50;
		}

		try
		{
			// ���ֱ���
			Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();
			hints.put(EncodeHintType.CHARACTER_SET, CODE);

			BitMatrix bitMatrix = new MultiFormatWriter().encode(str,
					BarcodeFormat.CODE_128, width, height, hints);
			//BarcodeFormat.EAN_13, width, height, hints);

			return toBufferedImage(bitMatrix);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * ���ɶ�ά�룬д���ļ���
	 * 
	 * 
	 * @param str
	 * @param height
	 * @param file
	 * @throws IOException
	 */
	public static void getRQWriteFile(String str, Integer height, File file)
			throws IOException
	{
		BufferedImage image = getRQ(str, height);
		ImageIO.write(image, "png", file);
	}

	/**
	 * ����һά�룬д���ļ���
	 * 
	 * 
	 * @param str
	 * @param height
	 * @param file
	 * @throws IOException
	 */
	public static void getBarcodeWriteFile(String str, Integer width,
			Integer height, File file) throws IOException
	{
		BufferedImage image = getBarcode(str, width, height);
		ImageIO.write(image, "png", file);
	}

	/**
	 * ת����ͼƬ
	 * 
	 * 
	 * @param matrix
	 * @return
	 */
	private static BufferedImage toBufferedImage(BitMatrix matrix)
	{
		int width = matrix.getWidth();
		int height = matrix.getHeight();
		System.out.println("Height:"+width);
		System.out.println("Width:"+height);
		BufferedImage image = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_ARGB);
		for (int x = 0; x < width; x++)
		{
			for (int y = 0; y < height; y++)
			{
				image.setRGB(x, y, matrix.get(x, y) ? BLACK : WHITE);
			}
		}
		return image;
	}

	/**
	 * ����(��ά��һά����)
	 */
	public static String read(File file)
	{

		BufferedImage image;
		try
		{
			if (file == null || file.exists() == false)
			{
				throw new Exception(" File not found:" + file.getPath());
			}

			image = ImageIO.read(file);
//			System.out.println("Height:"+image.getHeight());
//			System.out.println("Width:"+image.getWidth());
			//�������Ͻ�������
			LuminanceSource source = new BufferedImageLuminanceSource(image,0,0,500,500);
			BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));

			Result result;

			// �������ñ��뷽ʽΪ��utf-8��
			Hashtable hints = new Hashtable();
			hints.put(DecodeHintType.CHARACTER_SET, "utf-8");

			result = new MultiFormatReader().decode(bitmap, hints);

			return result.getText();

		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return null;
	}
	
	/**
	 * ����(��ά��һά����)
	 */
	public static String read(InputStream is)
	{

		BufferedImage image;
		try
		{
			if (is == null )
			{
				throw new Exception(" InputStream is null!");
			}

			image = ImageIO.read(is);

			LuminanceSource source = new BufferedImageLuminanceSource(image,0,0,2000,2000);
			BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));

			Result result;

			// �������ñ��뷽ʽΪ��utf-8��
			Hashtable hints = new Hashtable();
			hints.put(DecodeHintType.CHARACTER_SET, "utf-8");

			result = new MultiFormatReader().decode(bitmap, hints);

			return result.getText();

		}
		catch (Exception e)
		{
			ARE.getLog().warn("δ�����������룬��ͼƬ���ܲ�������ͼ��");
		}

		return null;
	}

	public static void main(String[] args) throws Exception
	{
		//File file = new File("c://1.jpg");
		//File file1 = new File("c://2.jpg");
//		// RQUtil.getRQwriteFile("�л����񹲺͹�", 200, file);
//
//		// code39 ��д��ĸ�����֡�-��
//		// code128 
		//QRUtil.getBarcodeWriteFile("2014071000000005", 400,100, file);
		//QRUtil.getRQWriteFile("2014071000000005", 100, file1);
//
//		System.out.println("-----�����ɹ�----");
//		System.out.println();

		String s = QRUtil.read(new File("c://Image2-nanhai.jpg"));
		//String s = QRUtil.read(new File("D://tmp//als//Image//2014//09//04//20140904161936_59758748.png"));
		//String s = QRUtil.read(file);

		System.out.println("-----�����ɹ�----");
		System.out.println(s);
	}


}
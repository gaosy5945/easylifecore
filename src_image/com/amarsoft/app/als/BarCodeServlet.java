package com.amarsoft.app.als;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
public class BarCodeServlet  extends HttpServlet{

	private static final long serialVersionUID = 332233L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		String TypeNo =  req.getParameter("TypeNo");
		String TypeName =  req.getParameter("TypeName");

//		String code = TypeNo+TypeName;
//		System.out.println(code);
		//BufferedImage image = QRUtil.getBarcode(TypeNo, 600, 150);
		BufferedImage image = QRUtil.getBarcode(TypeNo, 100, 50);
		//BufferedImage image = QRUtil.getRQ(TypeNo, 100);
		ImageIO.write(image, "png", resp.getOutputStream());
		
	}
}

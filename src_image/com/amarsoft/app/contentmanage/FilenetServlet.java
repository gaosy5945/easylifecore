package com.amarsoft.app.contentmanage;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.app.contentmanage.ContentManager;
import com.amarsoft.app.contentmanage.action.ContentManagerAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;

public class FilenetServlet  extends HttpServlet{

	private static final long serialVersionUID = 332233L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String fileNetDocId =  req.getParameter("fileNetDocId");
		String type_ =  req.getParameter("type_");
		if(type_==null) type_="view";
		
		ContentManager demo=ContentManagerAction.getContentManager();
		if(StringX.isEmpty(fileNetDocId) || demo==null) return ;
		fileNetDocId = URLDecoder.decode(fileNetDocId, "utf-8");
		ARE.getLog().trace("fileNetDocId:"+fileNetDocId);

		Content content = demo.get(fileNetDocId);
		InputStream inStream = content.getInputStream();
		String fileName = content.getName();
		String contentType = content.getContentType();
//		resp.reset();
		String browName = fileName;
		String clientInfo = req.getHeader("User-agent");
		if(clientInfo != null && clientInfo.indexOf("MSIE") > 0 ){
			//IE����URLEncoder��ʽ����
			if (clientInfo.indexOf("MSIE 6") > 0 || clientInfo.indexOf("MSIE 5") > 0) {
				// IE6����GBK���˴�ʵ�� �о�����
				browName = new String(fileName.getBytes(ARE.getProperty("CharSet","GBK")), "ISO-8859-1");
			} else {
				// ie7+��URLEncoder��ʽ
				browName = java.net.URLEncoder.encode(fileName, "UTF-8");
			}
		}
		ARE.getLog().trace(fileName +" " + contentType +"  "+ browName);
		resp.setContentType(contentType);
		if (type_.equals("view") && (contentType.startsWith("image") || contentType.startsWith("text")))
			resp.setHeader("Content-Disposition", "filename="+browName+";");
		else
			resp.setHeader("Content-Disposition", "attachment;filename="+browName+";");
		
		OutputStream outStream = resp.getOutputStream();
		int k=-1;
		byte[] bytes = new byte[10240];
		while ((k = inStream.read(bytes)) >0 ) {
			if (k >= 10240) {
				ARE.getLog().debug("Attachment Read:"+k);
			}
			outStream.write(bytes, 0, k);
		}
		inStream.close();
		outStream.flush();
		outStream.close();
	}
}
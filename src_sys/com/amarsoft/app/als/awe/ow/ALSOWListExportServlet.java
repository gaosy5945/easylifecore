package com.amarsoft.app.als.awe.ow;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.app.als.awe.ow.processor.impl.exportor.ALSOWListExport;


public class ALSOWListExportServlet extends HttpServlet{
	  private static final long serialVersionUID = 1L;

	  protected void doGet(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException{
		  doPost(req, resp);
	  }

	  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		  new ALSOWListExport().dosubmit(req, resp);
	  }
}
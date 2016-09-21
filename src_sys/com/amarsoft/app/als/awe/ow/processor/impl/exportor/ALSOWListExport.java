package com.amarsoft.app.als.awe.ow.processor.impl.exportor;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Random;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.export.datagenerators.AbExport;
import com.amarsoft.awe.dw.export.datagenerators.ExcelExport;
import com.amarsoft.awe.dw.export.datagenerators.HtmlExport;
import com.amarsoft.awe.dw.export.datagenerators.PdfExport;
import com.amarsoft.awe.dw.export.datagenerators.TxtExport;
import com.amarsoft.awe.dw.export.datagenerators2.AbExport2;
import com.amarsoft.awe.dw.export.datagenerators2.ExcelExport2;
import com.amarsoft.awe.dw.export.datagenerators2.HtmlExport2;
import com.amarsoft.awe.dw.export.datagenerators2.PdfExport2;
import com.amarsoft.awe.dw.export.datagenerators2.TxtExport2;
import com.amarsoft.awe.dw.export.servlet.ListExportServlet2;
import com.amarsoft.awe.dw.ui.control.Support;
import com.amarsoft.awe.task.TaskFactory;
import com.amarsoft.awe.task.TaskInfo;

public class ALSOWListExport extends ListExportServlet2 {
	public void dosubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		this.req = req;
		this.resp = resp;
		this.curPage = 0;
		this.GPageSize = 6000;
		
		if (req.getParameter("FileType") != null) {
			this.exportFileType = req.getParameter("FileType").toString();
		}

		if (req.getParameter("SERIALIZED_ASD") == null) {
			error("缺少参数SERIALIZED_ASD");
			return;
		}

		String serializedASD = req.getParameter("SERIALIZED_ASD").toString();
		try {
			this.asDataObject = Component.getDataObject(serializedASD);
		} catch (Exception e) {
			error("无法获取序列化SERIALIZED_ASD信息:" + e.getMessage());
			e.printStackTrace();
			return;
		}
		if ((req.getParameter("ConvertCode") != null)
				&& (req.getParameter("ConvertCode").toString().equals("1")))
			this.convertCode = true;
		else {
			this.convertCode = false;
		}
		String downLoadDir = "";
		try {
			Configure curConfig = Configure.getInstance(req.getSession().getServletContext());
			downLoadDir = curConfig.getConfigure("DWDownloadFilePath");

			File fileSS = new File(downLoadDir);
			if (!fileSS.exists())
				fileSS.mkdirs();
			this.downLoadDir = new File(downLoadDir);
			if (!this.downLoadDir.exists()) {
				error(this.downLoadDir + "目录不存在");
				return;
			}
		} catch (Exception e) {
			error("无法获得下载目录:" + e.getMessage());
			e.printStackTrace();
			return;
		}
		try {
			ALSBusinessProcess businessProcess = ALSBusinessProcess.createBusinessProcess(req, asDataObject,BusinessObjectManager.createBusinessObjectManager());
			BusinessObject inputParameters = ObjectWindowHelper.getDataObjectParameters(asDataObject);
			BusinessObjectOWQuerier querier = businessProcess.getBusinessObjectQuerier();
			querier.query(inputParameters,businessProcess);
			if (querier.getTotalCount()<= GPageSize) {//单页
				try {
					Random rand = new Random(); 
					directExport(querier,this.asDataObject.getDONO() + "_temp_"+ rand.nextInt(999999999) + "." + this.exportFileType, req, resp);
					req.getSession().setAttribute("CheckExportPage" + req.getParameter("rand"), "1");
					ARE.getLog().trace("set session:CheckExportPage"+ req.getParameter("rand"));
				} catch (Exception e) {
					e.printStackTrace();
					ARE.getLog().error("导出失败" + e.toString());
				}
			} 
			else {
				resetExportFileType();
				long lCount = this.rowCount * this.asDataObject.Columns.size();
				ARE.getLog().trace("rowCount=" + this.rowCount + ",colcount="+ this.getDisplayColumnNames(this.asDataObject.Columns).length + ",lcount= "+ lCount);
				if ((lCount > 100L * PdfMaxRowCount) && (this.exportFileType.equalsIgnoreCase("pdf"))) {
					this.exportFileType = "xls";
				} 
				else if ((this.rowCount > ExcelMaxRowCount)&& ((this.exportFileType.equalsIgnoreCase("excel")) || (this.exportFileType.equalsIgnoreCase("xls")))) {
					this.exportFileType = "xls";
				}

				Random rand = new Random();
				if ((this.exportFileType.equalsIgnoreCase("excel"))|| (this.exportFileType.equalsIgnoreCase("xls")))
					this.exportFileType = "xls";
				String sFileName0 = "/" + this.asDataObject.getDONO() + "_temp_"+ rand.nextInt(999999999) + "." + this.exportFileType;
				String sFileName = this.downLoadDir.getAbsolutePath() + sFileName0;

				ARE.getLog().trace("======导出" + this.exportFileType + ":" + sFileName0 + "["+ sFileName + "]");
				String sUserID = getCurUser(req).getUserID();
				TaskInfo taskInfo = TaskFactory.createTaskInfo("FileDownLoad","文件下载", "", sUserID, sUserID, "file", downLoadDir+ sFileName0 + ".zip");
				String sTaskID = "";
				try {
					sTaskID = TaskFactory.getTaskAction().registTask(taskInfo);
				} catch (Exception e) {
					e.printStackTrace();
					error("注册任务失败:" + e.getMessage());
				}
				int exportCount=0;
				this.pageCount=querier.getTotalCount()/GPageSize;
				if(GPageSize*pageCount<querier.getTotalCount())pageCount++;
				while (exportCount < querier.getTotalCount()) {
					try {
						int torownum=exportCount+GPageSize;
						if(torownum>querier.getTotalCount())torownum=querier.getTotalCount();
						write2File(querier,sFileName, req,exportCount,torownum);
						this.curPage++;
						exportCount+=GPageSize;
						ARE.getLog().trace("EXP_" + this.asDataObject.getDONO() + ",完成"+ exportCount * 100 / querier.getTotalCount() + "%");
					} 
					catch (Exception e) {
						error("输出出现错误:" + e.getMessage());
						e.printStackTrace();
						return;
					}
				}
				zipFileEx(downLoadDir + sFileName0, downLoadDir + sFileName0+ ".zip");
				TaskFactory.getTaskAction().finishTask(sTaskID, true);
				resp.setCharacterEncoding(ARE.getProperty("CharSet","GBK"));
				req.getSession().setAttribute("CheckExportPage" + req.getParameter("rand"), "1");
				resp.getWriter().println("<meta http-equiv=Content-Type content=\"text/html; charset="+ARE.getProperty("CharSet","GBK")+"\">");
				resp.getWriter().println("<span style='font-size:12px;' >数据已经导出，请到工作台上的“我的下载”中查看，编号为："+ sTaskID + "。</span>");
				this.datas.clear();
			}
		} catch (Exception e) {
			e.printStackTrace();
			error("完成任务失败:" + e.getMessage());
		}
	}
	
	protected void write2File(BusinessObjectOWQuerier querier,String tempFileName, HttpServletRequest req,int from,int to) throws Exception{
		BusinessObject[] businessObjectList = querier.getBusinessObjectList(from, to);
		for(BusinessObject o:businessObjectList){
			this.listJBO.add(o);
		}
	    fillHeadAndData();

	    AbExport2 exportGenerator = null;
	    if (this.exportFileType.equalsIgnoreCase("html")) {
	    	exportGenerator = new HtmlExport2();
	    } else if (this.exportFileType.equalsIgnoreCase("txt")) {
	    	exportGenerator = new TxtExport2();
	    } else if ((this.exportFileType.equalsIgnoreCase("csv")) || (this.exportFileType.equalsIgnoreCase("xls"))) {
	    	exportGenerator = new ExcelExport2();
	    	((ExcelExport2)exportGenerator).setColumFormat(getColumnFormats(this.asDataObject.Columns));
	    } else if (this.exportFileType.equalsIgnoreCase("pdf")) {
	    	exportGenerator = new PdfExport2();
	    	((PdfExport2)exportGenerator).setCurPage(this.curPage);
	    } else {
	    	String sClassName = "com.amarsoft.eas.exports.datagenerators2." + this.exportFileType + "Export2";
	    	exportGenerator = (AbExport2)Class.forName(sClassName).newInstance();
	    }
	    exportGenerator.setStartRow(from);
	    exportGenerator.setLastPage(this.curPage == this.pageCount - 1);
	    Object exportdata = exportGenerator.convertData(this.curPage == 0 ? this.headers : null, this.datas);
	    exportGenerator.export(tempFileName, exportdata);
	    this.datas.clear();
	    exportdata = null;
	}
	
	protected String[] getColumnFormats(Vector columns){
	    if (columns == null) return null;
	    ArrayList result = new ArrayList();
	    for (int i = 0; i < columns.size(); i++) {
	      ASColumn column = (ASColumn)columns.get(i);
	      if (!"1".equals(column.getAttribute("COLVISIBLE")))
	        continue;
	      String sCheckFormat = column.getAttribute("COLCHECKFORMAT");
	      if(StringX.isEmpty(sCheckFormat))sCheckFormat="1";
	      if (sCheckFormat.equals("2")) {
	        result.add("#,##0.00");
	      } else if ((sCheckFormat.equals("1")) || (sCheckFormat.equals("3")) || (sCheckFormat.equals("4"))) {
	        result.add("@");
	      } else if (sCheckFormat.equals("5")) {
	        result.add("#,##0");
	      } else {
	        int iDot = 0;
	        try {
	          int iCheckFValue = Integer.parseInt(sCheckFormat);
	          if (iCheckFValue > 10)
	            iDot = iCheckFValue - 10;
	          String sDotCheck = "";
	          for (int ii = 0; ii < iDot; ii++) {
	            sDotCheck = sDotCheck + "0";
	          }
	          if (sDotCheck.length() > 0)
	            result.add("#,##0." + sDotCheck);
	          else
	            result.add("#,##0");
	        } catch (Exception e) {
	          result.add("@");
	        }
	      }
	    }
	    return (String[])(String[])result.toArray(new String[0]);
	}
	
	protected void directExport(BusinessObjectOWQuerier querier,String fileName, HttpServletRequest req, HttpServletResponse response) throws Exception{
		BusinessObject[] businessObjectList = querier.getBusinessObjectList(0, querier.getTotalCount());
		for(BusinessObject o:businessObjectList){
			this.listJBO.add(o);
		}
	    fillHeadAndData();
	    AbExport exportGenerator = null;
	    if (this.exportFileType.equalsIgnoreCase("html")) {
	      exportGenerator = new HtmlExport();
	    } else if (this.exportFileType.equalsIgnoreCase("txt")) {
	      exportGenerator = new TxtExport();
	    } else if ((this.exportFileType.equalsIgnoreCase("csv")) || (this.exportFileType.equalsIgnoreCase("xls")) || (this.exportFileType.equalsIgnoreCase("excel"))) {
	      exportGenerator = new ExcelExport();
	      ((ExcelExport)exportGenerator).setColumFormat(getColumnFormats(this.asDataObject.Columns));
	    } else if (this.exportFileType.equalsIgnoreCase("pdf")) {
	      exportGenerator = new PdfExport();
	    } else {
	      String sClassName = "com.amarsoft.eas.exports.datagenerators." + this.exportFileType + "Export2";
	      exportGenerator = (AbExport)Class.forName(sClassName).newInstance();
	    }
	    Object exportdata = exportGenerator.convertData(this.curPage == 0 ? this.headers : null, this.datas);
	    exportGenerator.export(fileName, exportdata, response);
	    this.datas.clear();
	    exportdata = null;
	}

	protected void fillHeadAndData() throws Exception {
		Vector columns = this.asDataObject.Columns;
		if (columns == null)
			throw new Exception("没有可导出的字段");
		String[] visibleColumnNames = getDisplayColumnNames(columns);

		if (this.listJBO != null) {
			String[][] codeArray = new String[visibleColumnNames.length][];
			for (int j = 0; j < visibleColumnNames.length; j++) {
				ASColumn column = this.asDataObject
						.getColumn(visibleColumnNames[j]);
				codeArray[j] = Support.getCodes(
						column.getAttribute("COLEDITSOURCE"),
						column.getAttribute("COLEDITSOURCETYPE"));
			}
			for (int i = 0; i < this.listJBO.size(); i++) {
				BusinessObject businessObject = (BusinessObject) this.listJBO
						.get(i);
				String[] data = new String[visibleColumnNames.length];
				for (int j = 0; j < visibleColumnNames.length; j++) {
					String stringValue = "";
					Object value = businessObject
							.getObject(visibleColumnNames[j]);
					if (value != null) {
						int iDot = 0;
						String checkFormat = this.asDataObject
								.getColumnAttribute(visibleColumnNames[j],
										"ColCheckFormat");
						if (StringX.isEmpty(checkFormat))
							checkFormat = "1";
						if (checkFormat.equals("2"))
							iDot = 2;
						else {
							try {
								int iCheckFValue = Integer
										.parseInt(checkFormat);
								if (iCheckFValue > 10)
									iDot = iCheckFValue - 10;
							} catch (Exception e) {
							}
						}
						String sDotCheck = "";
						for (int ii = 0; ii < iDot; ii++) {
							sDotCheck = sDotCheck + "0";
						}
						if (sDotCheck.length() > 0)
							sDotCheck = "." + sDotCheck;
						DecimalFormat df2 = new DecimalFormat("####"
								+ sDotCheck);
						if ((checkFormat.equals("1"))
								|| (checkFormat.equals("3"))
								|| (checkFormat.equals("4"))) {
							stringValue = businessObject
									.getString(visibleColumnNames[j]);
						} else if (checkFormat.equals("5")) {
							df2 = new DecimalFormat("####");
							stringValue = df2.format(Arith.round(businessObject
									.getInt(visibleColumnNames[j]), 0));
						} else if (checkFormat.equals("6")) {
							df2 = new DecimalFormat("####");
							stringValue = df2
									.format(Arith.round(
											businessObject
													.getInt(visibleColumnNames[j]) / 10000L,
											0));
						} else if (checkFormat.equals("7")) {
							df2 = new DecimalFormat("####.00");
							stringValue = df2.format(Arith.round(businessObject
									.getDouble(visibleColumnNames[j]) / 10000.0D,
									2));
						} else if (checkFormat.matches("[0-9]+")) {
							stringValue = df2.format(Arith.round(businessObject
									.getDouble(visibleColumnNames[j]), iDot));
						} else {
							stringValue = businessObject
									.getString(visibleColumnNames[j]);
						}
						
						if ((this.convertCode) && (codeArray[j] != null)) {
							for (int ii = 0; ii < codeArray[j].length; ii += 2) {
								if (codeArray[j][ii].equals(stringValue)) {
									stringValue = codeArray[j][(ii + 1)];
									break;
								}
							}
						}
					}
					if (stringValue.equals("")) stringValue = "&nbsp;";
					data[j] = stringValue;
				}
				this.datas.add(data);
			}
		}

		this.listJBO.clear();
	}
	
	protected void resetExportFileType(){
	    if ((this.exportFileType.equalsIgnoreCase("excel")) || (this.exportFileType.equalsIgnoreCase("xls")))
	      this.exportFileType = "xls";
	    if (this.exportFileType.equalsIgnoreCase("pdf"))
	      this.exportFileType = "txt";
	}
}

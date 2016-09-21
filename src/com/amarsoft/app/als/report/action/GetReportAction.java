package com.amarsoft.app.als.report.action;

import com.amarsoft.app.als.report.model.ReportManage;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.lang.StringX;

/**
 * 调查报告相关
 * @author  xfliu
 */
public class GetReportAction {
	private String objectNo = "";
	private String objectType = "";
	private String docID = "";
	
	/**
	 * 获取调查报告编号
	 * @return
	 * @throws Exception
	 */
	public String getReportDocID() throws Exception{
		BizObject reportRecord = ReportManage.reportRecord(objectNo, objectType);
		if(reportRecord != null){
			String docID = reportRecord.getAttribute("DocID").getString();
			if(StringX.isSpace(docID)) docID = "";
			return docID;
		}
		return "";
	}
	/**
	 * 判断报告文件是否存在
	 * @return
	 * @throws Exception
	 */
	public String isExistFile() throws Exception{
		BizObject reportRecord = ReportManage.reportRecord(objectNo, objectType);
		if(reportRecord != null){
			String savePath = reportRecord.getAttribute("SavePath").getString();
			if(StringX.isSpace(savePath)) savePath = "";
			java.io.File file = new java.io.File(savePath);
			if(file.exists()){
				return "TRUE";
			}
		}
		return "FALSE";
	}
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	public String getObjectType() {
		return objectType;
	}
	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}
	
}

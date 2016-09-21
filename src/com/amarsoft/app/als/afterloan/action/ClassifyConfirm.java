package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;


/**
 * 分类偏离度确认生效
 * @author qzhang2
 *
 */
public class ClassifyConfirm {
	private String serialNo;
	private String classifyResult;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getClassifyResult() {
		return classifyResult;
	}

	public void setClassifyResult(String classifyResult) {
		this.classifyResult = classifyResult;
	}


	public String confirm(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bom);
		BizObjectQuery bq = bom.createQuery("SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.serialNo);
		BizObject cr = bq.getSingleResult(true);	
		
		/*
		String sAdjustedGrade="";
		String[] systemResult =SYSNameManager.getFiveClassify(this.classifyResult);
		String[] finalGrade =SYSNameManager.getFiveClassify(cr.getAttribute("FINALGRADE").getString());
		String[] adjustedGrade =SYSNameManager.getFiveClassify(cr.getAttribute("ADJUSTEDGRADE").getString());
		int i = Integer.parseInt(systemResult[0]) - Integer.parseInt(finalGrade[0]);
		if (i>0){
			int iFinalGrade=Integer.parseInt(adjustedGrade[0]) +i;
			if (iFinalGrade ==5 || iFinalGrade ==4) iFinalGrade = 9;
			else if (iFinalGrade ==3 ) iFinalGrade = 8;
			else if (iFinalGrade ==2 ) iFinalGrade = 6;
			sFinalGrade="0"+iFinalGrade;
			cr.setAttributeValue("FINALGRADE",sFinalGrade);
			bom.saveObject(cr);
			return "确认完成！";
		}*/
		String systemResult = this.classifyResult;
		String finalGrade =cr.getAttribute("FINALGRADE").getString();
		String adjustedGrade =cr.getAttribute("ADJUSTEDGRADE").getString();
		int i = Integer.parseInt(systemResult) - Integer.parseInt(finalGrade);
		int j = Integer.parseInt(systemResult) - Integer.parseInt(adjustedGrade);
		if (i>0){
			if(j>0){
				int iAdjustedGrade=Integer.parseInt(adjustedGrade) +i;
				if (iAdjustedGrade >= 3) iAdjustedGrade = 3;
				cr.setAttributeValue("ADJUSTEDGRADE",String.valueOf(iAdjustedGrade));
				bom.saveObject(cr);
				return "确认完成！";
			}else if(j==0){
				int iAdjustedGrade=Integer.parseInt(adjustedGrade) +1;
				if (iAdjustedGrade >= 3) iAdjustedGrade = 3;
				cr.setAttributeValue("ADJUSTEDGRADE",String.valueOf(iAdjustedGrade));
				bom.saveObject(cr);
				return "确认完成！";
			}else{
				return "不符合确认条件，请人工调整！";	
			}
		}else{
			return "不符合确认条件，请人工调整！";	
		}
	}
}

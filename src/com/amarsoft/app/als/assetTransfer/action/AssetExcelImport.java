package com.amarsoft.app.als.assetTransfer.action;

import java.util.Map;
import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.app.als.sys.tools.CodeGenerater;
/**
 * 描述：资产导入
 * @author fengcr
 * @2014
 */
public class AssetExcelImport extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmPA;
	private int count=0;
	
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmPA = JBOFactory.getBizObjectManager("jbo.prj.PRJ_ASSET_INFO");
			trans.join(bmPA);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	public boolean process(Map<String, DataElement> excelMap){
		count++;
		boolean result = false;
		if(this.rollBack) return result;
		try {
			String projectSerialno = getCurPage().getParameter("ProjectSerialno");
			String bdSerialNo = excelMap.get("BDSERIALNO").getString();//借据流水号
			BizObject bdbiz = JBOFactory.getFactory()
					.getManager("jbo.app.BUSINESS_DUEBILL")
					.createQuery("O.SERIALNO = :DUEBILLSERIALNO")
					.setParameter("DUEBILLSERIALNO", bdSerialNo).getSingleResult(true);
			Double actualBusinessRate = 0.0;
			Double balance = 0.0;
			BizObject pabiz = bmPA
					.createQuery("O.OBJECTNO = :DUEBILLSERIALNO and O.ObjectType = 'jbo.app.BUSINESS_DUEBILL' and O.ProjectSerialNo = :ProjectSerialNo")
					.setParameter("DUEBILLSERIALNO", bdSerialNo)
					.setParameter("ProjectSerialNo", projectSerialno)
					.getSingleResult(true);
			if(bdbiz == null){
				result = false;
				rollBack = true;
			}else if(pabiz == null){
				actualBusinessRate = bdbiz.getAttribute("ACTUALBUSINESSRATE").getDouble();
				balance = bdbiz.getAttribute("BALANCE").getDouble();
				BizObject boPA = bmPA.newObject();
				boPA.setAttributeValue("OBJECTTYPE", "jbo.app.BUSINESS_DUEBILL");
				boPA.setAttributeValue("OBJECTNO", bdSerialNo);
				boPA.setAttributeValue("PROJECTSERIALNO", projectSerialno);
				boPA.setAttributeValue("ACTUALBUSINESSRATE", actualBusinessRate);
				boPA.setAttributeValue("BALANCE", balance);
				boPA.setAttributeValue("STATUS","01");
				bmPA.saveObject(boPA);
				result = true;
			}else {
				actualBusinessRate = bdbiz.getAttribute("ACTUALBUSINESSRATE").getDouble();
				balance = bdbiz.getAttribute("BALANCE").getDouble();
				pabiz.setAttributeValue("ACTUALBUSINESSRATE", actualBusinessRate);
				pabiz.setAttributeValue("BALANCE", balance);
				bmPA.saveObject(pabiz);
				result = true;
			}
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}
		
		return result;
	}

	public void end() {
		if(rollBack){
			this.manger.sucessNum=0;
			this.manger.failNum=count;
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("事务回滚出错");
			}
		}else{
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("事务提交出错");
			}
		}
	}
	

}

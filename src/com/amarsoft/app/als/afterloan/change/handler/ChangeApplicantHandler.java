package com.amarsoft.app.als.afterloan.change.handler;


import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * 描述：共同借款人变更关联处理交易信息
 * @author xjzhao
 * @2015-01-04
 */
public class ChangeApplicantHandler extends CommonHandler {

	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		
		BusinessObject applier = BusinessObject.convertFromBizObject(bo);
		String objectType = applier.getString("ObjectType");
		String objectNo = applier.getString("ObjectNo");
		String applicantID = applier.getString("ApplicantID");
		
		List<BusinessObject> applicantList = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLICANT", "ObjectType=:ObjectType and "
				+ "ObjectNo=:ObjectNo and ApplicantID=:ApplicantID and ApplicantType in ('01','03') and Status in ('01','02') ", "ObjectType",objectType, 
				"ObjectNo",objectNo,"ApplicantID",applicantID);
		if(applicantList != null && applicantList.size() > 0) throw new Exception("该共同还款人已存在");
	}
	
	@Override
	protected void afterInsert(JBOTransaction tx,BizObject bo) throws Exception {
	
		String changeFlag = this.asPage.getParameter("ChangeFlag");
		if("Y".equals(changeFlag))
		{
			BusinessObject document = BusinessObject.convertFromBizObject(bo);
			String transSerialNo = this.asPage.getParameter("TransSerialNo");
			String transCode = this.asPage.getParameter("TransCode");
			String objectType = this.asPage.getParameter("ObjectType");
			String objectNo = this.asPage.getParameter("ObjectNo");
			
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
			
			Item item = CodeCache.getItem("ChangeCode", transCode);
			if(item == null) throw new Exception("该变更交易代码【"+transCode+"】不存在，请确认！");
			bom.updateDB();
		}

	}

}

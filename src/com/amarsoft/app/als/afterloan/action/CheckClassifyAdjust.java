package com.amarsoft.app.als.afterloan.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 校验分类调整是否有在途申请
 * @author 张琼
 */

public class CheckClassifyAdjust {
	private String duebillSerialNo;

	
	public String getDuebillSerialNo() {
		return duebillSerialNo;
	}


	public void setDuebillSerialNo(String duebillSerialNo) {
		this.duebillSerialNo = duebillSerialNo;
	}


	public String check(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bom);
		BizObjectQuery bq = bom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and ClassifyStatus in ('0010','0020')");
		bq.setParameter("ObjectNo", this.duebillSerialNo);
		bq.setParameter("ObjectType", "jbo.app.BUSINESS_DUEBILL");

		List<BizObject> crlist = bq.getResultList(false);
		if(crlist == null || crlist.isEmpty()) return "true";
		return "该借据存在在途分类调整申请，不能再次发起申请！";
			
	}
}

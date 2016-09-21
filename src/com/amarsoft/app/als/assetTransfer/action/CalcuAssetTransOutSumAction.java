/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.action;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.assetTransfer.model.ProjectAdjustHistory;
import com.amarsoft.app.als.assetTransfer.model.ProjectAssetRela;
import com.amarsoft.app.als.assetTransfer.model.ProjectInfo;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectJBOClass;
import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;

/**
 * 描述：	计算项目转出金额
 * @author fengcr
 * @2014-12-31
 */
public class CalcuAssetTransOutSumAction {
	
	private String projectNo;
	
	/**
	 * 描述：计算项目转出金额
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String calcuAssetTransOutSumAction(JBOTransaction tx) throws Exception{
		BizObjectManager bmBD = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		tx.join(bmBD);
		ProjectInfo info = new ProjectInfo(tx,projectNo);
		List<BizObject> list = null;
		try{
			list = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_INFO").createQuery("O.ObjectType = 'jbo.app.BUSINESS_DUEBILL' and O.PROJECTSERIALNO = :serialNo").setParameter("serialNo",projectNo).getResultList();
		}catch(JBOException e){
			e.printStackTrace();
		}
		//项目转出金额
		Double assetTransOutSum = 0.0;
		for(BizObject biz : list){
			String obejctNo = biz.getAttribute("OBJECTNO").toString();
			double transferRate = biz.getAttribute("TRANSFERRATE").getDouble();
			BizObject bdbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL").createQuery("O.SERIALNO = :serialNo").setParameter("serialNo",obejctNo).getSingleResult();
			double balance = bdbiz.getAttribute("BALANCE").getDouble();
			assetTransOutSum += balance * transferRate;
		}
		String assetTransOutSumStr = assetTransOutSum.toString();
		return assetTransOutSumStr;
	}
	

	public String getProjectNo() {
		return projectNo;
	}

	public void setProjectNo(String projectNo) {
		this.projectNo = projectNo;
	}
}
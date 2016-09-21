package com.amarsoft.app.als.assetTransfer.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;
/**
 * √Ë ˆ£∫
 * @author fengcr
 * @2014
 */
public class AssetReturnOrder {
	
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;

	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	
	public String UpdateAssetReturnOrder(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String SerialNo = (String)inputParameter.getValue("SerialNo");
		String ProjectType = (String)inputParameter.getValue("ProjectType");
		String TranferPercent = (String)inputParameter.getValue("TranferPercent");
		String RepayOrder = (String)inputParameter.getValue("RepayOrder");
		try{
			BizObjectManager bm = null;
			if("0201".equals(ProjectType)){
				bm = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_TRANSFER");
	 		}else if("0203".equals(ProjectType)){
				bm = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_SECURITIZATION");
			}
			
			tx.join(bm);
			BizObject bo = bm.createQuery("O.PROJECTSERIALNO = :PROJECTSERIALNO").setParameter("PROJECTSERIALNO", SerialNo).getSingleResult();
			boolean isAddflag = false;
			if(bo == null){
				isAddflag = true;
			}else{
				isAddflag = false;
			}
			if(isAddflag == true){
				BizObject bo1 = bm.newObject();
				bo1.setAttributeValue("PROJECTSERIALNO", SerialNo);
				bo1.setAttributeValue("TRANFERPERCENT", TranferPercent);
				bo1.setAttributeValue("REPAYORDER", RepayOrder);
				bm.saveObject(bo1);
			}else{
				BizObjectQuery bq = bm.createQuery("update O set TRANFERPERCENT = :TranferPercent,REPAYORDER = :RepayOrder where PROJECTSERIALNO = :SerialNo")
								.setParameter("TranferPercent", TranferPercent).setParameter("RepayOrder", RepayOrder).setParameter("SerialNo", SerialNo);
				bq.executeUpdate();
			}
			return "SUCCEED";
		}catch(Exception e){
			e.printStackTrace();
			return "FAILED";
		}
	}
	
	public String ShowAssetReturnOrder(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String ProjectSerialNo = (String)inputParameter.getValue("SerialNo");
		String ProjectType = (String)inputParameter.getValue("ProjectType");
		/*String TranferPercent = (String)inputParameter.getValue("TranferPercent");
		String RepayOrder = (String)inputParameter.getValue("RepayOrder");*/
		String parameters = "";
		if("0201".equals(ProjectType)){
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_TRANSFER");
			BizObject bo = bm.createQuery("O.PROJECTSERIALNO = :ProjectSerialNo").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult();
			String TranferPercent = bo.getAttribute("TRANFERPERCENT").toString();
			String RepayOrder = bo.getAttribute("REPAYORDER").toString();
			parameters = TranferPercent +"@" +RepayOrder;
		}else{
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_SECURITIZATION");
			BizObject bo = bm.createQuery("O.PROJECTSERIALNO = :ProjectSerialNo").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult();
			String TranferPercent = bo.getAttribute("TRANFERPERCENT").toString();
			String RepayOrder = bo.getAttribute("REPAYORDER").toString();
			parameters = TranferPercent +"@" +RepayOrder;
		}
		return parameters;
	}

}

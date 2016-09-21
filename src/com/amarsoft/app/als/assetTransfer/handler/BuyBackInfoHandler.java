/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.handler;

import com.amarsoft.app.als.assetTransfer.model.ProjectInfo;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 描述：	资产回购
 * @author xyli
 * @2014-4-25
 */
public class BuyBackInfoHandler extends CommonHandler {

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String objectNo = asPage.getParameter("ProjectNo");//项目编号
		
		ProjectInfo info = new ProjectInfo(null,objectNo);
		BizObject boPI = info.getBizObject();
		if(null != boPI){
			bo.setAttributeValue("PROJECTNO", objectNo);//项目编号
			bo.setAttributeValue("ProjectName", boPI.getAttribute("ProjectName").getString());//项目名称
			bo.setAttributeValue("ProjectType", boPI.getAttribute("ProjectType").getString());//项目类型
			bo.setAttributeValue("ProjectSum", boPI.getAttribute("ProjectSum").getDouble());//项目当前金额
			bo.setAttributeValue("BuyBackSum", boPI.getAttribute("BuyBackSum").getDouble());//回购金额
			bo.setAttributeValue("BuyBackDate", boPI.getAttribute("BuyBackDate").getString());//回购日期
			bo.setAttributeValue("OtherCondition", boPI.getAttribute("OtherCondition").getString());//其他回购条件
			bo.setAttributeValue("TransferUserID", boPI.getAttribute("TransferUserID").getString());//受让方
			bo.setAttributeValue("LaunchBank", boPI.getAttribute("LaunchBank").getString());//操作类型
			bo.setAttributeValue("TYPE", AssetProjectCodeConstant.BuyBackType_010);//类型(回购/返售)
		}
	}
	
	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		//对回购式的贷款转让项目按回购条件进行回购，项目阶段更新为已结清
		String objectNo = asPage.getParameter("ProjectNo");//项目编号
		
		ProjectInfo info = new ProjectInfo(tx);
		info.changeStatus(objectNo, AssetProjectCodeConstant.AssetProjectStatus_040);
	}
	
	
}

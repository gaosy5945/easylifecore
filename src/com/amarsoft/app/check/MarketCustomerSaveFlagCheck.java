package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;

/**
 * 自动风险探测中暂存状态检查
 * 
 * @author ckxu
 * @since 2015/12/21
 *
 */
public class MarketCustomerSaveFlagCheck extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		// 获取参数：对象类型和对象编号
		String flowSerialNo = (String) this.getAttribute("FlowSerialNo");
		if (flowSerialNo == null) {
			putMsg("申请基本信息未找到，请检查！");
			setPass(false);
			return false;
		}
		// 获取项目信息然后获取客户信息
		// 获取CustomerrID
		@SuppressWarnings("unchecked")
		List<BizObject> bos = JBOFactory
				.createBizObjectQuery("jbo.flow.FLOW_BUSINESSINFO",
						"FlowSerialNo=:FlowSerialNo")
				.setParameter("FlowSerialNo", flowSerialNo)
				.getResultList(false);
		if (bos == null || bos.size() < 1) {
			putMsg("申请基本信息未找到，请检查！");
			setPass(false);
			return false;
		}
		BusinessObject ba = BusinessObject.convertFromBizObject(bos.get(0));
		BusinessObjectManager bom = BusinessObjectManager
				.createBusinessObjectManager();
		BusinessObject ent = bom.loadBusinessObject("jbo.customer.ENT_INFO",
				"CUSTOMERID", ba.getAttribute("CustomerID").getString());
		String tempSave = ent.getAttribute("TEMPSAVEFLAG").getString();
		if (ent != null && tempSave.equals("1"))
			putMsg("申请人【" + ba.getString("CustomerName") + "】信息状态为暂存，请保存信息");

		/* 返回结果处理 */
		if (messageSize() > 0)
			setPass(false);
		else
			setPass(true);
		return false;
	}
}

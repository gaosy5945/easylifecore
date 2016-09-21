package com.amarsoft.app.check.afterloan;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 业务申请自动风险探测场景参数初始化类 在本类中，使用了JBO，关于JBO的使用，请参考JBO相关文档
 * 
 * @author bhxiao
 * @date 2015/01/01
 *
 */
public class InitTransactionScenario extends Bizlet {

	/**
	 * 场景执行初始化时，会自动调用此方法
	 */
	@Override
	public Object run(Transaction Sqlca) throws Exception {

		String flowSerialNo = (String) this.getAttribute("FlowSerialNo");// 流程实例编号
		String taskSerialNo = (String) this.getAttribute("TaskSerialNo");// 流程任务编号
		String phaseNo = (String) this.getAttribute("PhaseNo");// 流程阶段编号
		JBOTransaction tx = null;

		ASValuePool as = new ASValuePool();
		try {
			tx = JBOFactory.createJBOTransaction();

			BusinessObjectManager bom = BusinessObjectManager
					.createBusinessObjectManager(tx);

			// 加载交易申请信息
			List<BusinessObject> transList = bom
					.loadBusinessObjects(
							"jbo.acct.ACCT_TRANSACTION",
							"SerialNo in (select FO.ObjectNo from jbo.flow.FLOW_OBJECT FO where FO.FlowSerialNo = :FlowSerialNo)",
							"FlowSerialNo", flowSerialNo);
			this.setAttribute("ObjectType", "jbo.acct.ACCT_TRANSACTION");
			this.setAttribute("ObjectNo", "${SerialNo}");

			for (BusinessObject trans : transList) {
				TransactionHelper.loadTransaction(trans, bom);
				String transCode = trans.getString("TransCode");
				as.setAttribute("TransCode", transCode);
				if (transCode.equals("2002"))
					as.setAttribute("2002TransSerialNo",
							trans.getString("SerialNo"));
			}

			// 审批信息
			BusinessObject ft = bom.keyLoadBusinessObject("jbo.flow.FLOW_TASK",
					taskSerialNo);
			BusinessObject fo = bom
					.loadBusinessObjects(
							"jbo.flow.FLOW_OBJECT",
							"select distinct FlowNo,FlowVersion from O where FlowSerialNo=:FlowSerialNo",
							"FlowSerialNo", flowSerialNo).get(0);

			as.setAttribute("Main", transList);// 交易申请信息
			as.setAttribute("FlowTask", ft);
			as.setAttribute("FlowObject", fo);
			as.setAttribute("FlowNo", fo.getString("FlowNo"));
			as.setAttribute("FlowVersion", fo.getString("FlowVersion"));
			BusinessObject flowCatalog = FlowConfig.getFlowCatalog(
					fo.getString("FlowNo"), fo.getString("FlowVersion"));
			BusinessObject flowModel = FlowConfig.getFlowPhase(
					fo.getString("FlowNo"), fo.getString("FlowVersion"),
					phaseNo);
			// 判断是否存在录入
			List<BusinessObject> flowModels = FlowConfig.getFlowPhases(fo
					.getString("FlowNo"));
			boolean inputFlag = false;
			for (BusinessObject fm : flowModels)
				if ("0030".equals(fm.getString("PhaseType")))
					inputFlag = true;
			String phaseType = flowModel.getString("PhaseType");
			if (!inputFlag
					&& ("0010".equals(phaseType) || "0020".equals(phaseType)))
				phaseType = "0030";

			as.setAttribute("FlowType", flowCatalog.getString("FlowType"));
			as.setAttribute("PhaseType", phaseType);
			as.setAttribute("FunctionID", flowModel.getString("FunctionID"));
			as.setAttribute("OpnTemplateNo",
					flowModel.getString("OpnTemplateNo"));

			bom.clear();
			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			throw e;
		}

		return as; // 返回业务对象集合
	}
}

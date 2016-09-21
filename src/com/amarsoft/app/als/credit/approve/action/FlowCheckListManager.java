package com.amarsoft.app.als.credit.approve.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.CreditCheckConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;

/**
 * 审查审批中信息核查数据存储管理类
 * @author jywen
 * 2016年2月15日
 */
public class FlowCheckListManager {
	private String ObjectType;
	private String ObjectNo;
	private String FlowNo;
	private String PhaseNo;
	private String checkListName;
	
	/**
	 * 获取checklist中配置的核查分组    将ID转换为字符串  ****start  edit by jywen 2016/02/04
	 * @author jywen
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String getCheckGroupIdsSavedInCheckList(Transaction Sqlca) throws Exception{
		BusinessObject checkList = CreditCheckConfig.getCheckList(FlowNo, PhaseNo, checkListName);
		List<BusinessObject> checkGroupList = CreditCheckConfig.getCheckGroups(checkList);
		StringBuffer sCheckGroupIds = new StringBuffer();
		for(BusinessObject checkGroup:checkGroupList){
			sCheckGroupIds = sCheckGroupIds.append("'"+checkGroup.getString("ID")+"',");
		}
		String checkGroupIds = sCheckGroupIds.substring(1, sCheckGroupIds.length()-2);
		String ViewCheckGroupIds = "";
		String sSql = "select distinct FC.CheckItemNo from Flow_Checklist FC where FC.ObjectType = '"+ ObjectType  +"'and FC.ObjectNo = '"+ ObjectNo  +"' and FC.CheckItemNo in ('"+ checkGroupIds + "')";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		while(rs.next()){
			ViewCheckGroupIds = ViewCheckGroupIds+"@"+rs.getString("CheckItemNo");
		}
		rs.getStatement().close();
		
		return ViewCheckGroupIds;
	}

	public String getObjectType() {
		return ObjectType;
	}

	public void setObjectType(String objectType) {
		this.ObjectType = objectType;
	}

	public String getObjectNo() {
		return ObjectNo;
	}

	public void setObjectNo(String objectNo) {
		this.ObjectNo = objectNo;
	}

	public String getFlowNo() {
		return FlowNo;
	}

	public void setFlowNo(String flowNo) {
		FlowNo = flowNo;
	}

	public String getPhaseNo() {
		return PhaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		PhaseNo = phaseNo;
	}

	public String getCheckListName() {
		return checkListName;
	}

	public void setCheckListName(String checkListName) {
		this.checkListName = checkListName;
	}

}

package com.amarsoft.app.als.customer.common;

import java.util.HashMap;

import com.amarsoft.app.awe.config.worktip.WorkTip;
import com.amarsoft.app.awe.config.worktip.WorkTipRun;
import com.amarsoft.app.awe.config.worktip.WorkTips;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 客户经理授信、审查审批工作提示
 * @author amarsoft
 *
 */
public class CLPackApply implements WorkTipRun {

	public WorkTips run(HashMap<String, String> params, ASUser CurUser, Transaction Sqlca) throws Exception {
		WorkTips tips = new WorkTips();
		
		ASResultSet rs = null;
		String sPhaseType = params.get("PhaseType");
		String[] aPhaseType = sPhaseType == null ? new String[]{} : sPhaseType.split(",");
		int iShowNum = 20;
		try{
			String sSql = "select " +
					"BA.CustomerID, " +
					"BA.CustomerName, " +
					"getItemName('OccurType', BA.OccurType) as OccurType, " +
					"getPhaseName(FO.FlowNo,FO.PhaseNo) as PhaseName" +
					//", BA.NewFlag02 " +
					" from FLOW_OBJECT FO, BUSINESS_APPLY BA where FO.ObjectNo = BA.SerialNo " +
					"and FO.ApplyType = 'CLPackApply' " +
					"and FO.UserId = :UserId ";
			for(int i = 0; i < aPhaseType.length; i++){
				if(i == 0) sSql += " and FO.PhaseType in (";
				else sSql += ",";
				sSql += ":PhaseType"+i;
				if(i == aPhaseType.length - 1) sSql += ")";
			}
			sSql += "and BA.PigeonholeDate is null " +
					"and BA.BusinessType <> '6666' " +
					"order by FO.ObjectNo desc ";
			SqlObject aSql = new SqlObject(sSql).setParameter("UserID", CurUser.getUserID());
			for(int i = 0; i < aPhaseType.length; i++){
				aSql.setParameter("PhaseType"+i, aPhaseType[i]);
			}
			rs = Sqlca.getASResultSet(aSql);
			int n = 0;
			while(rs.next()){
				if(++n > iShowNum) continue;
				String sText = "";
				// 是否紧急
				//if("010".equals(rs.getString("NewFlag02"))) sText += "<img src=\"AppMain/resources/images/fire.png\" style=\"margin-right:5px;\" />";
				//else sText += "<span style='width:10px;margin-right:5px;'></span>";
				sText += "<span style='width:180px;'>"+rs.getString("CustomerID")+"</span>" +
						"<span style='width:200px;'>"+rs.getString("CustomerName")+"</span>" +
						"<span style='width:80px;'>"+rs.getString("OccurType")+"</span>" +
						"<span style='width:120px;'>"+rs.getString("PhaseName")+"</span>";
				tips.information.add(new WorkTip(sText, "alert('*****')"));
			}
			if(n > iShowNum){
				// 最后一个【更多】表示剩余的记录
				WorkTip tip = new WorkTip("<span style='float:right;margin-right:180px;color:#f00;'>更多...</span>", "alert('*****')");
				tip.setNum(n - iShowNum);
				tips.information.add(tip);
			}
		}finally{
			if(rs != null) rs.close();
		}
		return tips;
	}

}

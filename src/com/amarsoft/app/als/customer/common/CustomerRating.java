package com.amarsoft.app.als.customer.common;

import java.util.HashMap;

import com.amarsoft.app.awe.config.worktip.WorkTip;
import com.amarsoft.app.awe.config.worktip.WorkTipRun;
import com.amarsoft.app.awe.config.worktip.WorkTips;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 客户待评级工作提示
 * @author amarsoft
 *
 */
public class CustomerRating implements WorkTipRun {

	public WorkTips run(HashMap<String, String> params, ASUser CurUser, Transaction Sqlca) throws Exception {
		WorkTips tips = new WorkTips();
		ASResultSet rs = null;
		int iShowNum = 20;
		try{
			String sSql = "SELECT " +
					"EI.CustomerID, " +
					"EI.EnterpriseName, " +
					"EC.MODELNAME, " +
					"ER.EVALUATEDATE, " +
					"EI.CREDITLEVEL " +
					"FROM EVALUATE_RECORD ER, ENT_INFO EI, EVALUATE_CATALOG EC " +
					"WHERE 1 = 1 " +
					"AND EC.MODELNO = ER.MODELNO " +
					"AND EI.CUSTOMERID = ER.OBJECTNO " +
					"AND ER.OBJECTTYPE = 'Customer' " +
					"AND ER.USERID = :USERID " +
					"AND FINISHDATE IS NULL " +
					"ORDER BY ER.EVALUATEDATE DESC";
			SqlObject asql = new SqlObject(sSql);
			asql.setParameter("UserID", CurUser.getUserID());
			rs = Sqlca.getASResultSet(asql);
			int n = 0;
			while(rs.next()){
				if(++n > iShowNum) continue;
				String sCreditLevel = rs.getString("CreditLevel");
				if(StringX.isSpace(sCreditLevel)) sCreditLevel = "首次评级";
				else sCreditLevel = "当前信用等级："+sCreditLevel;
				String sText = "<span style='width:25px;'>"+n+"、</span>" +
						"<span style='width:120px;'>"+rs.getString("CustomerID")+"</span>" +
						"<span style='width:200px;'>"+rs.getString("EnterpriseName")+"</span>" +
						"<span style='width:250px;'>"+rs.getString("ModelName")+"</span>" +
						"<span style='width:80px;'>"+rs.getString("EvaluateDate")+"</span>" +
						"<span style='width:280px;'>"+sCreditLevel+"</span>";
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

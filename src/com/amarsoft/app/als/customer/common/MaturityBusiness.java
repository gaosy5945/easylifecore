package com.amarsoft.app.als.customer.common;

import java.util.HashMap;

import com.amarsoft.app.awe.config.worktip.WorkTip;
import com.amarsoft.app.awe.config.worktip.WorkTipRun;
import com.amarsoft.app.awe.config.worktip.WorkTips;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 到期提醒信息工作提示
 * @author amarsoft
 *
 */
public class MaturityBusiness implements WorkTipRun {

	public WorkTips run(HashMap<String, String> params, ASUser CurUser, Transaction Sqlca) throws Exception {
		WorkTips tips = new WorkTips();
		
		int iShowNum = 20;
		ASResultSet rs = null;
		try{
			String sSql = "select " +
					"CustomerId, " +
					"CustomerName, " +
					"getBusinessName(BusinessType) as BusinessType, " +
					"getItemName('OccerType', OccurType) as OccurType, " +
					"BusinessSum, " +
					"Balance, " +
					"PutOutDate, " +
					"Maturity " +
					"from BUSINESS_CONTRACT where 1 = 1 " +
					"and (DeleteFlag = ' ' or DeleteFlag is null) " +
					"and (PigeonholeDate <> ' ' and PigeonholeDate is not null) " +
					"and ManageUserId = :ManageUserId " +
					"and Maturity < :Maturity " +
					"and Balance > 0 ";
			SqlObject asql = new SqlObject(sSql);
			asql.setParameter("ManageUserId", CurUser.getUserID());
			asql.setParameter("Maturity", new DateX().getDateString("yyyy/MM/dd"));
			
			rs = Sqlca.getASResultSet(asql);
			int n = 0;
			while(rs.next()){
				if(++n > iShowNum) continue;
				String sText = "<span style='width:25px;'>"+n+"、</span>" +
						"<span style='width:120px;'>"+rs.getString("CustomerId")+"</span>" +
						"<span style='width:200px;'>"+rs.getString("CustomerName")+"</span>" +
						"<span style='width:200px;'>"+rs.getString("BusinessType")+"</span>" +
						"<span style='width:80px;'>"+rs.getString("OccurType")+"</span>" +
						"<span style='width:120px;text-align:right;padding-right:20px;'>"+FORMAT.format(rs.getDouble("BusinessSum"))+"</span>" +
						"<span style='width:120px;text-align:right;padding-right:20px;'>"+FORMAT.format(rs.getDouble("Balance"))+"</span>" +
						"<span style='width:80px;'>"+rs.getString("PutOutDate")+"</span>" +
						"<span style='width:80px;'>"+rs.getString("Maturity")+"</span>";
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

package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 集团家谱提交复核前更新GROUP_FAMILY_VERSION和GROUP_INFO
 * @author 核算
 * @date 2015/12/10
 */
public class FamilyVersionApplyOpinionAction{
	
	private String sGroupID;//集团客户ID
	private String sVersionSeq;//家谱版本ID
	private String sUserID;//用户ID
	
	public String getsGroupID() {
		return sGroupID;
	}

	public void setsGroupID(String sGroupID) {
		this.sGroupID = sGroupID;
	}

	public String getsVersionSeq() {
		return sVersionSeq;
	}

	public void setsVersionSeq(String sVersionSeq) {
		this.sVersionSeq = sVersionSeq;
	}

	public String getsUserID() {
		return sUserID;
	}

	public void setsUserID(String sUserID) {
		this.sUserID = sUserID;
	}

	public String familyVersionApplyOpinionAction(JBOTransaction tx) throws Exception{
		Transaction Sqlca = Transaction.createTransaction(tx);
		 //将空值转化为空字符串
		 if(sGroupID == null) sGroupID = "";
		 if(sVersionSeq == null) sVersionSeq = "";
		 if(sUserID == null) sUserID = "";
		 
		 //定义变量
		 String returnValue = "0";
		 String sSql = "";
		 ASResultSet rs = null;	//查询结果集
		 String groupType2="";
		 
		// 根据集团客户编号，查询
		 sSql = " select GroupType2 from GROUP_INFO where GroupID = :GroupID ";
	     rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID", sGroupID));
			
        //获取查询结果 
		if(rs.next()){
			groupType2=rs.getString("GroupType2");
		}
		rs.getStatement().close();
		rs = null;	
		if(groupType2 == null) groupType2 = "";
	 
         //更新GROUP_FAMILY_VERSION和GROUP_INFO
		 Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_VERSION set EffectiveStatus=:EffectiveStatus,SubmitTime=:SubmitTime where GroupID=:GroupID and VersionSeq=:VersionSeq").
				setParameter("GroupID",sGroupID).
				setParameter("VersionSeq",sVersionSeq).
				setParameter("EffectiveStatus","1").
				setParameter("SubmitTime",DateX.format(new java.util.Date(), "yyyy/MM/dd")));
		
		 Sqlca.executeSQL(new SqlObject("update GROUP_INFO set FamilyMapStatus = :FamilyMapStatus where GroupID=:GroupID").
				setParameter("GroupID",sGroupID).
				setParameter("FamilyMapStatus","1"));
		
		 return returnValue;	
	}				
}

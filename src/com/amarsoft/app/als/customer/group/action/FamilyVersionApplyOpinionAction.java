package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���ż����ύ����ǰ����GROUP_FAMILY_VERSION��GROUP_INFO
 * @author ����
 * @date 2015/12/10
 */
public class FamilyVersionApplyOpinionAction{
	
	private String sGroupID;//���ſͻ�ID
	private String sVersionSeq;//���װ汾ID
	private String sUserID;//�û�ID
	
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
		 //����ֵת��Ϊ���ַ���
		 if(sGroupID == null) sGroupID = "";
		 if(sVersionSeq == null) sVersionSeq = "";
		 if(sUserID == null) sUserID = "";
		 
		 //�������
		 String returnValue = "0";
		 String sSql = "";
		 ASResultSet rs = null;	//��ѯ�����
		 String groupType2="";
		 
		// ���ݼ��ſͻ���ţ���ѯ
		 sSql = " select GroupType2 from GROUP_INFO where GroupID = :GroupID ";
	     rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID", sGroupID));
			
        //��ȡ��ѯ��� 
		if(rs.next()){
			groupType2=rs.getString("GroupType2");
		}
		rs.getStatement().close();
		rs = null;	
		if(groupType2 == null) groupType2 = "";
	 
         //����GROUP_FAMILY_VERSION��GROUP_INFO
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

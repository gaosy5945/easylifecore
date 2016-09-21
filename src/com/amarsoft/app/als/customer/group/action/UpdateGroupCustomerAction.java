package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 修改集团客户概况的后续操作
 * @author 核算
 */

public class UpdateGroupCustomerAction{
	private	String mgtOrgID;
	private	String keyMemberCustomerID;
	private	String mgtUserID;
	private	String groupType2;
	private	String oldGroupType2;
	private	String oldMgtOrgID;
	private	String oldMgtUserID;
	private	String oldKeyMemberCustomerID;
	private	String groupID;
	private	String userID;
	private	String sIsGroupMember;
	
	public String getMgtOrgID() {
		return mgtOrgID;
	}

	public void setMgtOrgID(String mgtOrgID) {
		this.mgtOrgID = mgtOrgID;
	}

	public String getKeyMemberCustomerID() {
		return keyMemberCustomerID;
	}

	public void setKeyMemberCustomerID(String keyMemberCustomerID) {
		this.keyMemberCustomerID = keyMemberCustomerID;
	}

	public String getMgtUserID() {
		return mgtUserID;
	}

	public void setMgtUserID(String mgtUserID) {
		this.mgtUserID = mgtUserID;
	}

	public String getGroupType2() {
		return groupType2;
	}

	public void setGroupType2(String groupType2) {
		this.groupType2 = groupType2;
	}

	public String getOldGroupType2() {
		return oldGroupType2;
	}

	public void setOldGroupType2(String oldGroupType2) {
		this.oldGroupType2 = oldGroupType2;
	}

	public String getOldMgtOrgID() {
		return oldMgtOrgID;
	}

	public void setOldMgtOrgID(String oldMgtOrgID) {
		this.oldMgtOrgID = oldMgtOrgID;
	}

	public String getOldMgtUserID() {
		return oldMgtUserID;
	}

	public void setOldMgtUserID(String oldMgtUserID) {
		this.oldMgtUserID = oldMgtUserID;
	}

	public String getOldKeyMemberCustomerID() {
		return oldKeyMemberCustomerID;
	}

	public void setOldKeyMemberCustomerID(String oldKeyMemberCustomerID) {
		this.oldKeyMemberCustomerID = oldKeyMemberCustomerID;
	}

	public String getGroupID() {
		return groupID;
	}

	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getsIsGroupMember() {
		return sIsGroupMember;
	}

	public void setsIsGroupMember(String sIsGroupMember) {
		this.sIsGroupMember = sIsGroupMember;
	}

	public Object updateGroupCustomerAction(JBOTransaction tx) throws Exception{
		Transaction Sqlca = Transaction.createTransaction(tx);
		//将空值转化为空字符串
		if(mgtOrgID == null) mgtOrgID = "";
		if(keyMemberCustomerID == null) keyMemberCustomerID = "";
		if(mgtUserID == null) mgtUserID = "";
		if(groupType2 == null) groupType2 = "";	
		if(oldGroupType2 == null) oldGroupType2 = "";
		if(oldMgtOrgID == null) oldMgtOrgID = "";
		if(oldMgtUserID == null) oldMgtUserID = "";
		if(oldKeyMemberCustomerID == null) oldKeyMemberCustomerID = "";
		if(groupID == null) groupID = "";
		if(userID == null) userID = "";
		if(sIsGroupMember == null) sIsGroupMember = "";
	
		/**
		 * 定义变量
		 */
		//实例化用户对象
		ASUser curUser = ASUser.getUser(userID,Sqlca);
		ASResultSet rs = null;						//查询结果集
		String returnValue = "0";
		ASUser curUser1 = ASUser.getUser(oldMgtUserID,Sqlca);
		String oldMgtOrgName=curUser1.getOrgName();
		ASUser curUser2 = ASUser.getUser(mgtUserID,Sqlca);
		String mgtOrgName=curUser2.getOrgName();
		
		//业务主办行变更
		if(!(oldMgtOrgID.equals(mgtOrgID))){
			//记录集团类型变化事件，插入记录至GROUP_EVENT
			String sChangeContext="业务主办行由 "+oldMgtOrgName+" 变更为 "+mgtOrgName;
			
			String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID",Sqlca);
			StringBuffer sbSql = new StringBuffer();
			SqlObject so ;								
			sbSql.append(" insert into GROUP_EVENT(") 	
				.append(" EventID,")					
				.append(" GroupID,")				
				.append(" EventType, ")		         
				.append(" OccurDate, ")	
				.append(" RefMemberID, ")	
				.append(" EventValue, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate, ")
				.append(" OldEventValue, ")	
				.append(" RefMemberName, ")	
				.append(" ChangeContext ")	
				.append(" )values(:EventID, :GroupID, :EventType, :OccurDate, :RefMemberID, :EventValue, :InputOrgID, :InputUserID, :InputDate," +
						" :UpdateDate, :OldEventValue, :RefMemberName, :ChangeContext )");
			so = new SqlObject(sbSql.toString());
			so.setParameter("EventID", sEventID).setParameter("GroupID", groupID).setParameter("EventType", "02").setParameter("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("RefMemberID", "").setParameter("EventValue", "").setParameter("InputOrgID",curUser.getOrgID() ).setParameter("InputUserID", curUser.getUserID());
			so.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("OldEventValue", oldMgtOrgID).setParameter("RefMemberName", "").setParameter("ChangeContext",sChangeContext );
			Sqlca.executeSQL(so);	
			
			
			//判断原主办客户经理是否为成员的客户经理
		    String sSql1="select *  from CUSTOMER_BELONG where CustomerID in " +
									"(select MemberCustomerID from GROUP_FAMILY_MEMBER  where VersionSeq = (select max(VersionSeq) from " +
									"  GROUP_FAMILY_MEMBER where GroupID = :GroupID) and GroupID = :GroupID " +
									") and BelongAttribute = '1' and UserID = :UserID ";
			boolean bExists=false;
	        rs = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("CustomerID", groupID).
	        		setParameter("GroupID",groupID).setParameter("UserID",oldMgtUserID));
	    	if(rs.next()){
				bExists = true;
			}
			rs.getStatement().close();
			rs = null;
			
	  		if(bExists == true){
	  			Sqlca.executeSQL(new SqlObject("update CUSTOMER_BELONG set BELONGATTRIBUTE= :BELONGATTRIBUTE,BELONGATTRIBUTE1= :BELONGATTRIBUTE1," +
		        " BELONGATTRIBUTE2= :BELONGATTRIBUTE2,BELONGATTRIBUTE3= :BELONGATTRIBUTE3 where CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID ").
				setParameter("CustomerID",groupID).
				setParameter("OrgID",oldMgtOrgID).
				setParameter("UserID",oldMgtUserID).
				setParameter("BELONGATTRIBUTE","2").
				setParameter("BELONGATTRIBUTE1","1").
				setParameter("BELONGATTRIBUTE2","2").
				setParameter("BELONGATTRIBUTE3","2"));
	  		}else{
				//删除原主办客户经理的权限  
	  			Sqlca.executeSQL(new SqlObject("delete from CUSTOMER_BELONG where CustomerID=:CustomerID").setParameter("CustomerID", groupID));
	  			
	  			//插入新记录至customer_belong表	
		  		String sSql = "insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3," +
					" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)"+
					" values (:CustomerID,:OrgID,:UserID,:BelongAttribute,:BelongAttribute1,:BelongAttribute2,:BelongAttribute3," +
					" :BelongAttribute4,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", groupID).setParameter("OrgID", mgtOrgID).setParameter("UserID", mgtUserID).setParameter("BelongAttribute", "1")
				.setParameter("BelongAttribute1", "1").setParameter("BelongAttribute2", "1").setParameter("BelongAttribute3", "1")
				.setParameter("BelongAttribute4", "1").setParameter("InputOrgID", curUser.getOrgID()).setParameter("InputUserID", curUser.getUserID())
				.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
				Sqlca.executeSQL(so);	
	  		}
			
		}
		
		//核心企业变更
		if(!(oldKeyMemberCustomerID.equals(keyMemberCustomerID))){
			
			/** 根据核心企业客户编号，查询对应的客户名称*/
		    String 	sSql2 = " select CustomerName from CUSTOMER_INFO WHERE CustomerID=:CustomerID ";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("CustomerID", oldKeyMemberCustomerID));
	        String sOldKeyMemberCustomerName="";
			if(rs.next()){
				sOldKeyMemberCustomerName = rs.getString("CustomerName");
			}
			rs.getStatement().close();
			rs = null;
			if(sOldKeyMemberCustomerName == null) sOldKeyMemberCustomerName = "";
			
			/** 根据核心企业客户编号，查询对应的客户名称*/
		    String 	sSql3 = " select CustomerName,CertType,CertID from CUSTOMER_INFO WHERE CustomerID=:CustomerID ";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql3).setParameter("CustomerID", keyMemberCustomerID));
	        String sKeyMemberCustomerName="";
	        String sMemberCertType="";
	        String sMemberCertID="";
			if(rs.next()){
				sKeyMemberCustomerName = rs.getString("CustomerName");
				sMemberCertType=rs.getString("CertType");
				sMemberCertID=rs.getString("CertID");
			}
			rs.getStatement().close();
			rs = null;
			if(sKeyMemberCustomerName == null) sKeyMemberCustomerName = "";
			if(sMemberCertType == null) sMemberCertType = "";
			if(sMemberCertID == null) sMemberCertID = "";
			
			//记录集团类型变化事件，插入记录至GROUP_EVENT
			String sChangeContext="核心公司由 "+sOldKeyMemberCustomerName+" 变更为 "+sKeyMemberCustomerName;
			
			String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID",Sqlca);
			StringBuffer sbSql1 = new StringBuffer();
			SqlObject so ;								
			sbSql1.append(" insert into GROUP_EVENT(") 	
				.append(" EventID,")					
				.append(" GroupID,")				
				.append(" EventType, ")		         
				.append(" OccurDate, ")	
				.append(" RefMemberID, ")	
				.append(" EventValue, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate, ")
				.append(" OldEventValue, ")	
				.append(" RefMemberName, ")	
				.append(" ChangeContext ")	
				.append(" )values(:EventID, :GroupID, :EventType, :OccurDate, :RefMemberID, :EventValue, :InputOrgID, :InputUserID, :InputDate," +
						" :UpdateDate, :OldEventValue, :RefMemberName, :ChangeContext )");
			so = new SqlObject(sbSql1.toString());
			so.setParameter("EventID", sEventID).setParameter("GroupID", groupID).setParameter("EventType", "04").setParameter("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("RefMemberID", groupID).setParameter("EventValue", "").setParameter("InputOrgID",curUser.getOrgID() ).setParameter("InputUserID", curUser.getUserID());
			so.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("OldEventValue", oldKeyMemberCustomerID).setParameter("RefMemberName","").setParameter("ChangeContext",sChangeContext);
			Sqlca.executeSQL(so);	
			
			//判断集团客户是否有已复核通过的家谱版本
		    String sSql4="select * from GROUP_MEMBER_RELATIVE where GroupID=:GroupID";
			String isGroupMember="false";
			rs = Sqlca.getASResultSet(new SqlObject(sSql4).setParameter("GroupID", groupID));
			if(rs.next()){
				isGroupMember = "true";
			}
			rs.getStatement().close();
			rs = null;
			
			//获取最新的集团家谱版本编号
			String 	sSql5 = " select RefVersionSeq,FamilyMapStatus from GROUP_INFO WHERE GroupID=:GroupID ";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql5).setParameter("GroupID", groupID));
	        String newVersionSeq="";
	        String newFamilyMapStatus="";
			if(rs.next()){
				newVersionSeq = rs.getString("RefVersionSeq");
				newFamilyMapStatus=rs.getString("FamilyMapStatus");
			}
			rs.getStatement().close();
			rs = null;
			if(newVersionSeq == null) newVersionSeq = "";
			if(newFamilyMapStatus == null) newFamilyMapStatus = "";

			if(isGroupMember.equals("true")){//当前集团有已复核通过的家谱版本
				//1.更改集团成员表中新的核心企业的信息
				Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
						setParameter("GroupID", groupID).
						setParameter("MemberCustomerID",keyMemberCustomerID).
						setParameter("ParentMemberID","None").
						setParameter("ParentRelationType","").
						setParameter("MemberType","01").
						setParameter("VersionSeq",newVersionSeq)
						);
				//2.更改集团成员表中原有核心企业的信息
				Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
						setParameter("GroupID", groupID).
						setParameter("MemberCustomerID",oldKeyMemberCustomerID).
						setParameter("ParentMemberID",keyMemberCustomerID).
						setParameter("ParentRelationType","01").
						setParameter("MemberType","02").
						setParameter("VersionSeq",newVersionSeq)
						);
				}else{//当前集团无已复核通过的家谱版本					
					//查询当前集团是否既有核心企业成员，又有一般成员
			        String haveMember="false";
					String 	sSql8 = " select count(*) A from GROUP_FAMILY_MEMBER WHERE GroupID=:GroupID and ParentMemberID<>:ParentMemberID";
			        rs = Sqlca.getASResultSet(new SqlObject(sSql8).setParameter("GroupID", groupID).setParameter("ParentMemberID","None"));
					if(rs.next()){
						if(Integer.parseInt(rs.getString("A")) > 0)
							haveMember="true";//有一般成员
					}
					rs.getStatement().close();
					rs = null;
					
					if(sIsGroupMember.equals("true")){//1.新的核心企业已是集团成员
						//1.1更改集团成员表中新的核心企业的信息
						Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
								setParameter("GroupID", groupID).
								setParameter("MemberCustomerID",keyMemberCustomerID).
								setParameter("ParentMemberID","None").
								setParameter("ParentRelationType","").
								setParameter("MemberType","01").
								setParameter("VersionSeq",newVersionSeq)
								);
						//1.2更改集团成员表中原有核心企业的信息
						Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
								setParameter("GroupID", groupID).
								setParameter("MemberCustomerID",oldKeyMemberCustomerID).
								setParameter("ParentMemberID",keyMemberCustomerID).
								setParameter("ParentRelationType","01").
								setParameter("MemberType","02").
								setParameter("VersionSeq",newVersionSeq)
								);
					}else if((sIsGroupMember.equals("false"))&&(haveMember.equals("false"))){//2.新核心企业不是集团成员，当前集团家谱只有一个核心企业，无一般成员存在												
						//2.1.删除旧的核心成员
						Sqlca.executeSQL(new SqlObject("delete from GROUP_FAMILY_MEMBER where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID").setParameter("GroupID", groupID).setParameter("MemberCustomerID", oldKeyMemberCustomerID));			  			
						//2.2.插入新记录至GROUP_FAMILY_MEMBER
						String sMemberID=DBKeyHelp.getSerialNo("GROUP_FAMILY_MEMBER","MemberID",Sqlca);		
						StringBuffer sbSql = new StringBuffer();
						SqlObject so1 ;
						sbSql.append(" insert into GROUP_FAMILY_MEMBER(") 
							.append(" MemberID,")	
							.append(" GroupID,")					
							.append(" VersionSeq,")				
							.append(" MemberName, ")		         
							.append(" MemberCustomerID, ")	
							.append(" MemberType, ")	
							.append(" MemberCertType, ")	
							.append(" MemberCertID, ")	
							.append(" MemberCorpID,")					
							.append(" ParentMemberID,")						         
							.append(" ReviseFlag, ")	
							.append(" InfoSource, ")	
							.append(" InputOrgID, ")	
							.append(" InputUserID, ")	
							.append(" InputDate, ")	
							.append(" UpdateDate ")	
							.append(" )values(:MemberID, :GroupID, :VersionSeq, :MemberName, :MemberCustomerID, :MemberType, " +
									         ":MemberCertType,:MemberCertID, :MemberCorpID, :ParentMemberID, :ReviseFlag,:InfoSource, " +
											 ":InputOrgID, :InputUserID, :InputDate, :UpdateDate )");
						so1 = new SqlObject(sbSql.toString());
						so1.setParameter("MemberID", sMemberID).setParameter("GroupID", groupID).setParameter("VersionSeq", newVersionSeq);
						so1.setParameter("MemberName", sKeyMemberCustomerName).setParameter("MemberCustomerID", keyMemberCustomerID);
						so1.setParameter("MemberType", "01").setParameter("MemberCertType", sMemberCertType).setParameter("MemberCertID", sMemberCertID).setParameter("MemberCorpID", "");
						so1.setParameter("ParentMemberID", "None").setParameter("ReviseFlag", "").setParameter("InfoSource", "").setParameter("InputOrgID", curUser.getOrgID());
						so1.setParameter("InputUserID", curUser.getUserID()).setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
						Sqlca.executeSQL(so1);		
						
					}else if((sIsGroupMember.equals("false"))&&(haveMember.equals("true"))){//3.新核心企业不是集团成员，但当前集团家谱有核心成员和一般成员存在	
						//1.插入新记录至GROUP_FAMILY_MEMBER
						String sMemberID=DBKeyHelp.getSerialNo("GROUP_FAMILY_MEMBER","MemberID",Sqlca);		
						StringBuffer sbSql = new StringBuffer();
						SqlObject so1 ;
						sbSql.append(" insert into GROUP_FAMILY_MEMBER(") 
							.append(" MemberID,")	
							.append(" GroupID,")					
							.append(" VersionSeq,")				
							.append(" MemberName, ")		         
							.append(" MemberCustomerID, ")	
							.append(" MemberType, ")	
							.append(" MemberCertType, ")	
							.append(" MemberCertID, ")	
							.append(" MemberCorpID,")					
							.append(" ParentMemberID,")						         
							.append(" ReviseFlag, ")	
							.append(" InfoSource, ")	
							.append(" InputOrgID, ")	
							.append(" InputUserID, ")	
							.append(" InputDate, ")	
							.append(" UpdateDate ")	
							.append(" )values(:MemberID, :GroupID, :VersionSeq, :MemberName, :MemberCustomerID, :MemberType, " +
									         ":MemberCertType,:MemberCertID, :MemberCorpID, :ParentMemberID, :ReviseFlag,:InfoSource, " +
											 ":InputOrgID, :InputUserID, :InputDate, :UpdateDate )");
						so1 = new SqlObject(sbSql.toString());
						so1.setParameter("MemberID", sMemberID).setParameter("GroupID", groupID).setParameter("VersionSeq", newVersionSeq);
						so1.setParameter("MemberName", sKeyMemberCustomerName).setParameter("MemberCustomerID", keyMemberCustomerID);
						so1.setParameter("MemberType", "01").setParameter("MemberCertType", sMemberCertType).setParameter("MemberCertID", sMemberCertID).setParameter("MemberCorpID", "");
						so1.setParameter("ParentMemberID", "None").setParameter("ReviseFlag", "").setParameter("InfoSource", "").setParameter("InputOrgID", curUser.getOrgID());
						so1.setParameter("InputUserID", curUser.getUserID()).setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
						Sqlca.executeSQL(so1);		
						//2.将旧的核心成员连同下挂子成员跟新的核心企业关联
						Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
								setParameter("GroupID", groupID).
								setParameter("MemberCustomerID",oldKeyMemberCustomerID).
								setParameter("ParentMemberID",keyMemberCustomerID).
								setParameter("ParentRelationType","01").
								setParameter("MemberType","02").
								setParameter("VersionSeq",newVersionSeq)
								);						
					}
					
			}
		}	
		
		//总行管理名单变更
		if(!(oldGroupType2.equals(groupType2))){		
			if(oldGroupType2.equals("1")){
				oldGroupType2="是总行管理名单";
			}else{
				oldGroupType2="非总行管理名单";
				}
			
			if(groupType2.equals("1")){
				groupType2="是总行管理名单";
			}else{
				groupType2="非总行管理名单";
				}

			//记录集团类型变化事件，插入记录至GROUP_EVENT
			String sChangeContext="由 "+oldGroupType2+" 变更为 "+groupType2;
			
			String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID",Sqlca);
			StringBuffer sbSql2 = new StringBuffer();
			SqlObject so ;								
			sbSql2.append(" insert into GROUP_EVENT(") 	
				.append(" EventID,")					
				.append(" GroupID,")				
				.append(" EventType, ")		         
				.append(" OccurDate, ")	
				.append(" RefMemberID, ")	
				.append(" EventValue, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate, ")
				.append(" OldEventValue, ")	
				.append(" RefMemberName, ")	
				.append(" ChangeContext ")	
				.append(" )values(:EventID, :GroupID, :EventType, :OccurDate, :RefMemberID, :EventValue, :InputOrgID, :InputUserID, :InputDate," +
						" :UpdateDate, :OldEventValue, :RefMemberName, :ChangeContext )");
			so = new SqlObject(sbSql2.toString());
			so.setParameter("EventID", sEventID).setParameter("GroupID", groupID).setParameter("EventType", "05").setParameter("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("RefMemberID", groupID).setParameter("EventValue", "").setParameter("InputOrgID",curUser.getOrgID() ).setParameter("InputUserID", curUser.getUserID());
			so.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("OldEventValue", oldKeyMemberCustomerID).setParameter("RefMemberName","").setParameter("ChangeContext",sChangeContext);
			Sqlca.executeSQL(so);	
		}	
		return returnValue;	
	}	
}

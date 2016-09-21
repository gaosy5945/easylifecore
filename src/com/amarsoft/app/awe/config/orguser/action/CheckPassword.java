package com.amarsoft.app.awe.config.orguser.action;

import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.security.MessageDigest;
import com.amarsoft.awe.security.LogonUser;
import com.amarsoft.awe.security.SecurityAudit;
import com.amarsoft.awe.security.SecurityOptionManager;
import com.amarsoft.awe.security.UserMarkInfo;
import com.amarsoft.awe.security.pwdrule.ALSPWDRules;
import com.amarsoft.awe.security.pwdrule.ComparePasswordRule;
import com.amarsoft.awe.security.pwdrule.PasswordRuleManager;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 登录密码修改
 * @author xdzhu
 * @since 2010-11-12
 * @version xhgao 2011-05-16 改用SqlObject，事务由外部调用逻辑控制
 * 			xhgao 2012-04-13  加密改为基于ARE提供的MD5算法
 */
public class CheckPassword {

	private String oldPassword; // 原密码
	private String newPassword; // 新密码
	private String userID; // 登录用户
	private String IsLogon;//判断是否一开始登录时修改密码，为1表示是
	private String LoginID;//loginID
	
	public String getOldPassword() {
		return oldPassword;
	}

	public void setOldPassword(String oldPassword) {
		this.oldPassword = oldPassword;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getUserID() {
		return userID;
	}
	
	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String checkPassword(JBOTransaction tx) throws Exception {
		//加密处理
		String sEncOldPassword = MessageDigest.getDigestAsUpperHexString("MD5", oldPassword);
		String sEncNewPassword = MessageDigest.getDigestAsUpperHexString("MD5", newPassword);
		
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.awe.USER_INFO",tx)
				.createQuery( "UserID=:UserID and Password=:Password")
				.setParameter("UserID",userID).setParameter("Password",sEncOldPassword);
		 
		if(query.getResultList(false).size() == 0)  return "原密码错误，请重新输入!"; 
		LoginID = query.getSingleResult().getAttribute("LoginID").getString();
		Transaction Sqlca = Transaction.createTransaction(tx);
		SecurityAudit securityAudit = new SecurityAudit(new LogonUser(ASUser.getUser(userID, Sqlca).getUserName(), userID, oldPassword));//安全审计里面可能需要判断密码是否包含大小写等问题，所以构建用户的时候，使用明码
		UserMarkInfo userMarkInfo = securityAudit.getUserMarkInfo(Sqlca);
		PasswordRuleManager pwm = new PasswordRuleManager();
		ComparePasswordRule compareRule = new ComparePasswordRule();
		ALSPWDRules alsPWDRules = new ALSPWDRules(SecurityOptionManager.getRules(Sqlca));
		pwm.addRule(compareRule);
		pwm.addRule(alsPWDRules);
		
		if(!securityAudit.modifyPassword(newPassword,pwm)) return securityAudit.getErrorMessage()+"，请重新输入!";
		
		
		//校验通过后,更新为新的密码
		/*if("1".equals(this.IsLogon)){*/
			JBOFactory.getBizObjectManager("jbo.sys.USER_INFO",tx)
			.createQuery("update O set Password=:Password WHERE LoginID =:LoginID")
			.setParameter("LoginID",this.LoginID).setParameter("Password",sEncNewPassword)
			.executeUpdate();
 		/*}else{
 			JBOFactory.getBizObjectManager("jbo.sys.USER_INFO",tx)
			.createQuery("update O set Password=:Password WHERE UserID =:UserID")
			.setParameter("UserID",userID).setParameter("Password",sEncNewPassword)
			.executeUpdate();
		}*/
		
		
		//保存用户痕迹信息
		userMarkInfo.setPasswordState("0");
		userMarkInfo.setPassWordUpdateDate(DateX.format(new java.util.Date()));
		userMarkInfo.saveMarkInfo(Sqlca);
		
		return "SUCCEEDED";
	}

	public String getIsLogon() {
		return IsLogon;
	}

	public void setIsLogon(String isLogon) {
		IsLogon = isLogon;
	}

	public String getLoginID() {
		return LoginID;
	}

	public void setLoginID(String loginID) {
		LoginID = loginID;
	}
}

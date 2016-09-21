package com.amarsoft.app.base.trans.common.checker;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 交易检查基础类
 * 
 * 未使用基础类<TransactionProcedure>作为校验的基础类，主要是避免项目组在写其他用途的继承类中写校验程序，这样不会在实际调用校验程序时体现。
 * 
 * @author Amarsoft 核算团队
 */
public class TransactionChecker extends TransactionProcedure {
	protected List<String> warningMessage = new ArrayList<String>();//用于存储提示性校验信息
	protected List<String> errorMessage = new ArrayList<String>();//用户存储错误（强制）性校验
	
	public int run() throws Exception {
		String preRunCheck = TransactionConfig.getTransactionConfig(transaction.getString("TransCode"), "PreRunCheck");
		if (!StringX.isEmpty(preRunCheck)) {
			preRunCheck = (String)ScriptConfig.executeELScript(preRunCheck, "transaction",transaction);
			if (!"true".equalsIgnoreCase(preRunCheck)) {
				errorMessage.add("交易执行前检查失败，【"+preRunCheck+"】。");
			}
		}
		return 1;
	}
	
	/**
	 * 获取提示性校验信息
	 * @return
	 */
	public List<String> getWarningMessage(){
		return warningMessage;
	}
	
	/**
	 * 获取错误性（强制性）校验
	 * @return
	 */
	public List<String> getErrorMessage(){
		return errorMessage;
	}
}

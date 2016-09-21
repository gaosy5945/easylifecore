package com.amarsoft.app.base.trans.common.checker;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * ���׼�������
 * 
 * δʹ�û�����<TransactionProcedure>��ΪУ��Ļ����࣬��Ҫ�Ǳ�����Ŀ����д������;�ļ̳�����дУ���������������ʵ�ʵ���У�����ʱ���֡�
 * 
 * @author Amarsoft �����Ŷ�
 */
public class TransactionChecker extends TransactionProcedure {
	protected List<String> warningMessage = new ArrayList<String>();//���ڴ洢��ʾ��У����Ϣ
	protected List<String> errorMessage = new ArrayList<String>();//�û��洢����ǿ�ƣ���У��
	
	public int run() throws Exception {
		String preRunCheck = TransactionConfig.getTransactionConfig(transaction.getString("TransCode"), "PreRunCheck");
		if (!StringX.isEmpty(preRunCheck)) {
			preRunCheck = (String)ScriptConfig.executeELScript(preRunCheck, "transaction",transaction);
			if (!"true".equalsIgnoreCase(preRunCheck)) {
				errorMessage.add("����ִ��ǰ���ʧ�ܣ���"+preRunCheck+"����");
			}
		}
		return 1;
	}
	
	/**
	 * ��ȡ��ʾ��У����Ϣ
	 * @return
	 */
	public List<String> getWarningMessage(){
		return warningMessage;
	}
	
	/**
	 * ��ȡ�����ԣ�ǿ���ԣ�У��
	 * @return
	 */
	public List<String> getErrorMessage(){
		return errorMessage;
	}
}

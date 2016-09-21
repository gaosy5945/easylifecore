package com.amarsoft.app.accounting.trans.script.common.executor;

import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * 反冲交易执行
 * 
 * @author Amarsoft核算团队
 * 
 */
public class ReverseTransactionExecutor extends BookKeepExecutor {

	@Override
	public int run() throws Exception {
		Map<String,List<BusinessObject>> details = createReverseDetail();//创建冲账反分录
		
		for(String bookType:details.keySet()){
			this.updateLedgerAccount(details.get(bookType));
			transaction.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail, details.get(bookType));
		}
		return 1;
	}
	
}

package com.amarsoft.app.awe.config.worktip;

import java.text.DecimalFormat;
import java.util.HashMap;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 根据传递的参数键值对获取工作提示接口
 * @author M·Winter
 *
 */
public interface WorkTipRun {

	DecimalFormat FORMAT = new DecimalFormat("###,##0.00");
	
	/**
	 * 执行获取工作提示，并返回转载工作提示的容器对象{@link WorkTips}
	 * @param params 获取工作提示的参数，参考{@link WorkTip#getAction()}第二段执行参数
	 * @param CurUser 当前用户对象
	 * @param Sqlca 数据连接
	 * @return 工作提示容器
	 * @throws Exception 
	 */
	WorkTips run(HashMap<String, String> params, ASUser CurUser, Transaction Sqlca) throws Exception;
}

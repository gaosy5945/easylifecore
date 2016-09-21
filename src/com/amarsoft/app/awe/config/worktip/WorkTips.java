package com.amarsoft.app.awe.config.worktip;

import java.util.ArrayList;

import com.amarsoft.are.util.json.JSONEncoder;

/**
 * 工作提示容器对象<br>
 * 包含提示信息列表，参考{@link WorkTip}，
 * 并通过{@link #getInformation()}获取值传递到客户端。
 * @author M·Winter
 *
 */
public class WorkTips {

	public final ArrayList<WorkTip> information = new ArrayList<WorkTip>();
	
	/**
	 * 获取JSON字符串传递到客户端
	 * @return
	 */
	public String getInformation(){
		return JSONEncoder.encode(information);
	}
}

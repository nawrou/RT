/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cl_main_krl_update_camera.c                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bsouchet <bsouchet@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/10 10:39:33 by qle-guen          #+#    #+#             */
/*   Updated: 2017/03/01 21:42:22 by bsouchet         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "cl_interface.h"
#include "libfmt.h"
#include "rt.h"

bool
	cl_main_krl_update_camera
	(t_cl *cl
	, t_obj *obj)
{
	int			ret;
	t_cl_cam	cam;

	assert(obj->type = 'C');
	cpy_cam(&cam, obj);
	if ((ret = cl_write(&cl->info, cl->main_krl.args[1], sizeof(cam), &cam))
		!= CL_SUCCESS)
		return (ERR("cannot set camera, err %a", false, ret));
	return (true);
}

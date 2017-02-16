/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cl                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: qle-guen <qle-guen@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/08 07:50:15 by qle-guen          #+#    #+#             */
/*   Updated: 2017/02/08 07:50:16 by qle-guen         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "obj_def.h"

#define PRINT3(v, a) printf(a ": %f %f %f\n", (v).x, (v).y, (v).z);

constant float2	size2	= (float2){WIDTH, HEIGHT};
constant float2	size2_2	= (float2){XCENTER, YCENTER};
constant float3	size3	= (float3){WIDTH, HEIGHT, 0};
constant float3	size3_2	= (float3){XCENTER, YCENTER, 0};

#include "calc.cl"

void
	debug
	(global t_obj *objs
	, global t_lgt *lgts
	, global t_cam *cam
	, short nobjs
	, short nlgts)
{
	short	i;

	i = 0;
	while (i < nobjs)
	{
		printf("obj %d\n", i);
		PRINT3(objs[i].pos, "pos");
		PRINT3(objs[i].rot, "rot");
		i++;
	}
	i = 0;
	while (i < nlgts)
	{
		printf("lgt %d\n", i);
		PRINT3(lgts[i].pos, "pos");
		PRINT3(lgts[i].rot, "rot");
		i++;
	}
	printf("active camera:\n");
	PRINT3((*cam).pos, "pos");
	PRINT3((*cam).rot, "rot");
	printf("-----------\n");
}

kernel void
	kernel_entry
	(global unsigned int *img_buffer
	, global t_cam *cam
	, global t_obj *objs
	, global t_lgt *lgts
	, short nobjs
	, short nlgts)
{
	float2	basis;
	float3	direction;
	float3	origin;
	size_t	x;
	size_t	y;

	x = get_global_id(0);
	y = get_global_id(1);
	if (x == 0 && y == 0)
		debug(objs, lgts, cam, nobjs, nlgts);
	basis.x = cam->pos.x;
	basis.y = cam->pos.y;
	basis += 0.5 * (1 + basis / size2);
	origin = cam->pos;
	direction.x = x * basis.x;
	direction.y = y * basis.y;
	direction.z = - cam->focal;
	calc(img_buffer + WIDTH * y + x
		, objs
		, lgts
		, nobjs
		, nlgts
		, origin
		, normalize(direction)
		, cam);
}

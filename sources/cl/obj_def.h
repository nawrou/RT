/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   obj_def.h                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bsouchet <bsouchet@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/10 10:34:17 by qle-guen          #+#    #+#             */
/*   Updated: 2017/05/11 17:37:54 by bsouchet         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef OBJ_DEF_H
# define OBJ_DEF_H
# ifndef M_PI
# define M_PI 3.14f
# endif
# define PREC 0.01f
# define PREC2 0.02f
# define PREC3 0.0002f
# define AMBIANT 0.2f
# define MAX_REFLECTION 1
# define MAX_TRANSPARANCY 1
# define FONT 0x000000FF

# include "../../include/obj_types.h"

typedef struct		s_obj
{
	short			type;
	float3			pos;
	float3			rot;
	float3			clr;
	float			opacity;
	float			width;
	float			height;
	float			radius;
	float			specular;
	float			reflex;
	float			refrac;
	short			shader;
	float			shiness;
	float			mshiness;
	float3			offset;
}					t_obj;

typedef struct		s_lgt
{
	float3			pos;
	float3			rot;
	float3			clr;
	float			intensity;
}					t_lgt;

typedef struct		s_cam
{
	float3			pos;
	float3			rot;
	short			focal;
}					t_cam;

#endif

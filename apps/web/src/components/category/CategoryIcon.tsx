"use client"

import * as Icons from "lucide-react"
import type { LucideProps } from "lucide-react"

type Props = LucideProps & {
  name: string
}

function toPascalCase(str: string): string {
  return str
    .split("-")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join("")
}

export function CategoryIcon({ name, ...props }: Props) {
  const iconName = name ? toPascalCase(name) : "Circle"
  const IconsMap = Icons as unknown as Record<string, React.FC<LucideProps>>
  const Icon = IconsMap[iconName]

  if (!Icon) {
    const Fallback = Icons.Circle as React.FC<LucideProps>
    return <Fallback {...props} />
  }

  return <Icon {...props} />
}

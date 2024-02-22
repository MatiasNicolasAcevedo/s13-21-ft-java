import { PiArrowSquareDown, PiArrowSquareRight, PiArrowSquareUp } from 'react-icons/pi'

export default function ActionButton ({ info, option }) {
  let Icon

  // Asign the icon acording to the iconType received
  switch (option) {
    case 'option1':
      Icon = PiArrowSquareDown
      break
    case 'option2':
      Icon = PiArrowSquareRight
      break
    case 'option3':
      Icon = PiArrowSquareUp
      break
    default:
      Icon = null
  }

  return (
    <button className='flex justify-between items-center border gap-2 rounded-xl overflow-hidden'>
      <p className='pl-3'>{info}</p>
      <div className='p-3 bg-gradient-to-b from-green-500 to-lime-400 h-full'>
        {Icon ? <Icon className='text-[28px] text-white' /> : null}
      </div>
    </button>
  )
}